import sys
import time
import requests
from fastapi.testclient import TestClient

from biocentral_server.main import app

client = TestClient(app)

# Dummy test sequence data
SEQS_TRAIN = {
    "P1": "MKVLWAALLVTFLAGCQAKVEQAVETEPEPELRQQTEWQSGQRWELALGRFWDYLRWVQTLSEQVQEELLSSQVTQELR",
    "P2": "MKVLWAALLVTFLAGCQAKVEQAVETEPEPELRQQTEWQSGQRWELALGRFWDYLRWVQTLSEQVQEELLSSQVTQELA",
    "P3": "MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIEQWFTEDPGPDEAPRMPEAAPPVAPAPAA",
}

SEQS_QUERY = {
    "P1_mut": "MKVLWAALLVTFLAGCQAKVEQAVETEPEPELRQQTEWQSGQRWELALGRFWDYLRWVQTLSEQVQEELLSSQVTQE",
    "P3_mut": "MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIEQWFTEDPGPDEAPRMPEAAPPVAPAP",
}

TRAIN_LABELS_CLS = {"P1": "cytoplasm", "P2": "cytoplasm", "P3": "nucleus"}
QUERY_LABELS_CLS = {"P1_mut": "cytoplasm", "P3_mut": "nucleus"}

TRAIN_LABELS_REG = {"P1": 1.25, "P2": 1.30, "P3": 8.90}
QUERY_LABELS_REG = {"P1_mut": 1.20, "P3_mut": 8.85}


def test_regular_protein_clustering_endpoint(is_live: bool = False, base_url: str = "http://localhost:9540"):
    """Tests standard MMseqs2 background task clustering in protein_service."""
    print("\n--- Testing Regular MMseqs2 Protein Clustering ---")
    url = f"{base_url}/api/v1/protein_service/cluster/"
    payload = {
        "sequence_data": SEQS_TRAIN,
        "sequence_identity_threshold": 0.5,
    }

    if is_live:
        resp = requests.post(url, json=payload)
    else:
        resp = client.post("/api/v1/protein_service/cluster/", json=payload)

    assert resp.status_code == 200, f"Failed submitting cluster task: {resp.text}"
    data = resp.json()
    assert "task_id" in data, f"Expected task_id in response, got: {data}"
    task_id = data["task_id"]
    print(f"[OK] Cluster task submitted successfully. Task ID: {task_id}")


def test_cluster_hbi_endpoint(is_live: bool = False, base_url: str = "http://localhost:9540"):
    """Tests Cluster-HBI endpoint with dataset caching under custom_models_service."""
    print("\n--- Testing Cluster HBI with Dataset Caching ---")
    url = f"{base_url}/api/v1/custom_models_service/cluster-hbi/"

    # Call 1: With sequences (populates cache)
    payload_initial = {
        "dataset_hash": "test_hash_proteins_123",
        "sequence_identity_threshold": 0.3,
        "sequence_data": SEQS_TRAIN,
        "target_data": TRAIN_LABELS_CLS,
        "is_numeric": False,
        "iterations": 10,
    }

    if is_live:
        resp = requests.post(url, json=payload_initial)
    else:
        resp = client.post("/api/v1/custom_models_service/cluster-hbi/", json=payload_initial)

    assert resp.status_code == 200, f"Cluster HBI initial call failed: {resp.text}"
    res = resp.json()
    assert "metrics" in res and len(res["metrics"]) > 0, "No metrics returned"
    assert "clusters" in res, "Missing clusters dictionary in response"
    assert isinstance(res["clusters"], dict)

    first_metric = res["metrics"][0]
    for key in ["name", "mean", "lower", "upper", "iterations", "sample_size"]:
        assert key in first_metric, f"Missing '{key}' in bootstrapped metric"
    print(
        f"[OK] Initial Cluster-HBI succeeded. Primary metric: {first_metric['name']} = "
        f"{first_metric['mean']:.3f} [{first_metric['lower']:.3f}, {first_metric['upper']:.3f}]"
    )

    # Call 2: Without sequences (retrieves from cache)
    payload_cached = {
        "dataset_hash": "test_hash_proteins_123",
        "sequence_identity_threshold": 0.8,
        "target_data": TRAIN_LABELS_CLS,
        "is_numeric": False,
        "iterations": 10,
    }

    if is_live:
        resp_cached = requests.post(url, json=payload_cached)
    else:
        resp_cached = client.post("/api/v1/custom_models_service/cluster-hbi/", json=payload_cached)

    assert resp_cached.status_code == 200, f"Cluster HBI cached call failed: {resp_cached.text}"
    print("[OK] Cached sequence re-clustering succeeded.")


def test_split_hbi_classification(is_live: bool = False, base_url: str = "http://localhost:9540"):
    """Tests Split-HBI endpoint for classification under custom_models_service."""
    print("\n--- Testing Split HBI (Classification) ---")
    url = f"{base_url}/api/v1/custom_models_service/split-hbi/"
    payload = {
        "train_seqs": SEQS_TRAIN,
        "query_seqs": SEQS_QUERY,
        "train_labels": TRAIN_LABELS_CLS,
        "query_labels": QUERY_LABELS_CLS,
        "evalue_cutoff": 10.0,
        "min_seq_id": 0.0,
        "is_numeric": False,
        "iterations": 15,
    }

    if is_live:
        resp = requests.post(url, json=payload)
    else:
        resp = client.post("/api/v1/custom_models_service/split-hbi/", json=payload)

    assert resp.status_code == 200, f"Split HBI classification failed: {resp.text}"
    res = resp.json()
    assert res["hits_found"] > 0, "Expected homology hits between train and query"
    acc_metric = next((m for m in res["metrics"] if m["name"] == "accuracy"), None)
    assert acc_metric is not None, "Accuracy metric not found in metrics list"
    assert acc_metric["iterations"] == 15
    print(
        f"[OK] Split-HBI Classification evaluated {res['evaluated_queries']} queries. "
        f"Accuracy: {acc_metric['mean'] * 100:.1f}% [{acc_metric['lower'] * 100:.1f}% - {acc_metric['upper'] * 100:.1f}%]"
    )


def test_split_hbi_regression(is_live: bool = False, base_url: str = "http://localhost:9540"):
    """Tests Split-HBI endpoint for numeric regression targets."""
    print("\n--- Testing Split HBI (Regression) ---")
    url = f"{base_url}/api/v1/custom_models_service/split-hbi/"
    payload = {
        "train_seqs": SEQS_TRAIN,
        "query_seqs": SEQS_QUERY,
        "train_labels": TRAIN_LABELS_REG,
        "query_labels": QUERY_LABELS_REG,
        "evalue_cutoff": 10.0,
        "min_seq_id": 0.0,
        "is_numeric": True,
        "iterations": 15,
    }

    if is_live:
        resp = requests.post(url, json=payload)
    else:
        resp = client.post("/api/v1/custom_models_service/split-hbi/", json=payload)

    assert resp.status_code == 200, f"Split HBI regression failed: {resp.text}"
    res = resp.json()
    assert len(res["metrics"]) > 0
    first = res["metrics"][0]
    print(
        f"[OK] Split-HBI Regression metric: {first['name']} = "
        f"{first['mean']:.3f} [{first['lower']:.3f}, {first['upper']:.3f}]"
    )


def test_split_hbi_seed_scan(is_live: bool = False, base_url: str = "http://localhost:9540"):
    """Tests that the seed scan returns one result per seed, consistent with a single Split-HBI call."""
    print("\n--- Testing Split HBI Seed Scan ---")
    url = f"{base_url}/api/v1/custom_models_service/split-hbi-seed-scan/"
    payload = {
        "sequences": {**SEQS_TRAIN, **SEQS_QUERY},
        "labels": {**TRAIN_LABELS_CLS, **QUERY_LABELS_CLS},
        "splits": [
            # Seed 0 is the same split as in test_split_hbi_classification
            {"seed": 0, "train_ids": list(SEQS_TRAIN), "query_ids": list(SEQS_QUERY)},
            {"seed": 1, "train_ids": ["P2", "P3_mut"], "query_ids": ["P1", "P3"]},
        ],
        "evalue_cutoff": 10.0,
        "min_seq_id": 0.0,
        "is_numeric": False,
        "iterations": 15,
    }

    if is_live:
        resp = requests.post(url, json=payload)
    else:
        resp = client.post("/api/v1/custom_models_service/split-hbi-seed-scan/", json=payload)

    assert resp.status_code == 200, f"Split HBI seed scan failed: {resp.text}"
    results = {r["seed"]: r for r in resp.json()["results"]}
    assert set(results) == {0, 1}, f"Expected results for seeds 0 and 1, got: {list(results)}"
    assert results[0]["hits_found"] == 2, "Seed 0 should find a train hit for both queries"
    acc_metric = next((m for m in results[0]["metrics"] if m["name"] == "accuracy"), None)
    assert acc_metric is not None and acc_metric["mean"] == 1.0, "Seed 0 queries should inherit their correct labels"
    print(f"[OK] Seed scan evaluated {len(results)} seeds. Seed 0 accuracy: {acc_metric['mean'] * 100:.1f}%")


if __name__ == "__main__":
    is_live = "--live" in sys.argv
    target = "Live Server (http://localhost:9540)" if is_live else "In-process TestClient"
    print(f"Running test suite against: {target}")

    test_regular_protein_clustering_endpoint(is_live=is_live)
    test_cluster_hbi_endpoint(is_live=is_live)
    test_split_hbi_classification(is_live=is_live)
    test_split_hbi_regression(is_live=is_live)
    test_split_hbi_seed_scan(is_live=is_live)

    print("\n[SUCCESS] All tests passed successfully.")
