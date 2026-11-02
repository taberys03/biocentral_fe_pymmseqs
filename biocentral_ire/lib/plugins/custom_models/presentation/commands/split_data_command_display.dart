import 'dart:async';
import 'dart:math';

import 'package:bio_flutter/bio_flutter.dart';
import 'package:biocentral/plugins/custom_models/bloc/models_commands.dart';
import 'package:biocentral/sdk/biocentral_sdk.dart';
import 'package:biocentral/sdk/bloc/biocentral_command_availability.dart';
import 'package:biocentral/sdk/domain/biocentral_database_column.dart';
import 'package:biocentral/sdk/model/split_set.dart';
import 'package:biocentral/sdk/presentation/widgets/biocentral_command_widget.dart';
import 'package:biocentral/sdk/presentation/widgets/biocentral_ratio_slider.dart';
import 'package:biocentral/sdk/util/widget_util.dart';
import 'package:biocentral_api/biocentral_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:biocentral/plugins/proteins/domain/protein_repository.dart';
import 'package:biocentral/plugins/custom_models/model/set_generator.dart';

class SplitDataCommandDisplay extends StatefulWidget {
  const SplitDataCommandDisplay({super.key});

  @override
  State<SplitDataCommandDisplay> createState() => _SplitDataCommandDisplayState();
}

class _SplitDataCommandDisplayState extends State<SplitDataCommandDisplay> {
  final Set<SplitSetGenerationMethod> _availableMethods = const {
    SplitSetGenerationMethod.random,
    SplitSetGenerationMethod.existingCluster,
    SplitSetGenerationMethod.newCluster,
  };
  final Map<BiocentralDatabaseColumn, Set<SplitSet>> _availableSourceSets = {};

  Type? _selectedDatabaseType = Protein;
  int? _selectedDatabaseLength;
  SplitSetGenerationMode? _mode;
  BiocentralDatabaseColumn? _selectedSetColumn;
  SplitSet? _subsplitSource;
  SplitSet? _subsplitTarget;
  SplitSetGenerationMethod? _method;
  SplitRatio? _splitRatio;
  String? _selectedClusterColumn;
  double _clusteringThreshold = 0.3;

  // Seed scan: split HBI is evaluated for seeds 0.._numSeeds-1 and the seed closest to the median is selected
  int _numSeeds = 30;
  int _seed = 0;
  List<SeedHBIResult>? _seedScanResults;

  // Target column for evaluation & HBI
  String? _selectedTargetColumn;

  // HBI Evaluation & Plot State
  Timer? _debounceTimer;
  bool _isEvaluatingHBI = false;
  String? _hbiErrorMessage;
  // Incremented per evaluation, so responses of outdated evaluations are discarded
  int _evaluationRequestId = 0;

  // BootstrappedMetric from Backend
  List<BootstrappedMetric>? get _splitHbiMetrics =>
      _seedScanResults?.where((result) => result.seed == _seed).firstOrNull?.metrics.toList();
  List<BootstrappedMetric>? _clusterHbiMetrics;

  //Cluster distribution data for plotting
  Map<String, List<String>>? _computedClusters;

  final double _eValueThreshold = 1e-3;

  // Below this number of test sequences, evaluation metrics become unreliable
  static const int _minTestSequences = 20;

  /// Clusters used for the preview split: the selected cluster column for existing clusterings,
  /// the clusters returned by the cluster HBI endpoint for new clusterings, null for random splits
  Map<String, List<String>>? _resolveClusters(List<Map<String, dynamic>> entities) {
    if (_method == SplitSetGenerationMethod.newCluster) {
      return _computedClusters;
    }
    if (_method != SplitSetGenerationMethod.existingCluster || _selectedClusterColumn == null) {
      return null;
    }
    final clusters = <String, List<String>>{};
    for (final e in entities) {
      final id = e['id']?.toString() ?? '';
      final clusterId = _getEntityAttribute(e, _selectedClusterColumn!)?.toString() ?? id;
      clusters.putIfAbsent(clusterId, () => []).add(id);
    }
    return clusters;
  }

  /// Computes the split mapping that the command would produce with the current configuration
  /// and the given [seed] (defaults to the selected seed)
  Map<String, SplitSet>? _computePreviewSplit({int? seed}) {
    if (_method == null || _splitRatio == null) return null;
    final isSubsplit = _mode == SplitSetGenerationMode.subsplitExisting;
    if (isSubsplit && (_selectedSetColumn == null || _subsplitSource == null || _subsplitTarget == null)) {
      return null;
    }
    final database = context.read<BiocentralDatabaseRepository>().getFromType(_selectedDatabaseType);
    if (database == null) return null;

    final entities = database.entitiesAsMaps();
    final ids = isSubsplit
        ? _selectedSetColumn!.ids
        : entities.map((e) => e['id']?.toString() ?? '').where((id) => id.isNotEmpty).toList();

    return SetGenerator(splitRatio: _splitRatio!).splitByMethod(
      method: _method!,
      ids: ids,
      clusters: _resolveClusters(entities),
      seed: seed ?? _seed,
      subsplitSource: _subsplitSource,
      subsplitTarget: _subsplitTarget,
    );
  }

  List<String> getDiscoveredClusterColumns() {
    final database = context.read<BiocentralDatabaseRepository>().getFromType(_selectedDatabaseType);
    if (database is ProteinRepository) {
      return database.getAvailableClusterColumns();
    }
    return [];
  }

  List<String> getAvailableTargetColumns() {
    final database = context.read<BiocentralDatabaseRepository>().getFromType(_selectedDatabaseType);
    if (database == null) return [];

    final Set<String> discoveredColumns = {};

    // Collect all unique keys present across all entities
    final entities = database.entitiesAsMaps();
    for (final entity in entities) {
      final attributes = entity['attributes'] as Map<String, dynamic>?;
      if (attributes != null) {
        discoveredColumns.addAll(attributes.keys);
      }
      discoveredColumns.addAll(
        entity.keys.where((k) => k != 'id' && k != 'sequence' && k != 'attributes'),
      );
    }

    // Exclude IDs, sequence strings, and partition columns
    return discoveredColumns.where((col) {
      final lower = col.toLowerCase().trim();
      if (lower.startsWith('set_') || lower.startsWith('mmseqs2-cluster-')) return false;
      if (lower == 'sequence' || lower == 'id' || lower == 'proteinid' || lower == 'repid') return false;
      return true;
    }).toList();
  }

  void triggerAutoEvaluation() {
    _debounceTimer?.cancel();

    // Verify all mandatory preconditions are satisfied
    if (_selectedDatabaseType == null ||
        _selectedTargetColumn == null ||
        _mode == null ||
        _method == null ||
        _splitRatio == null) {
      return;
    }
    if (_method == SplitSetGenerationMethod.existingCluster && _selectedClusterColumn == null) {
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _runDualHbiEvaluation();
    });
  }

  Future<void> _runDualHbiEvaluation() async {
    if (!mounted) return;

    final requestId = ++_evaluationRequestId;
    bool isOutdated() => !mounted || requestId != _evaluationRequestId;

    setState(() {
      _isEvaluatingHBI = true;
      _hbiErrorMessage = null;
    });

    try {
      final database = context.read<BiocentralDatabaseRepository>().getFromType(_selectedDatabaseType);
      final api = context.read<BiocentralAPIRepository>().getBiocentralAPI();
      if (database == null) {
        setState(() => _isEvaluatingHBI = false);
        return;
      }

      final entities = database.entitiesAsMaps();
      final isNumeric = _isColumnNumeric(_selectedTargetColumn!);
      final allSeqs = <String, String>{};
      final allTargets = <String, dynamic>{};
      for (final e in entities) {
        final id = e['id']?.toString() ?? '';
        final rawVal = _getEntityAttribute(e, _selectedTargetColumn!);
        final val = isNumeric ? double.tryParse(rawVal?.toString() ?? '') : rawVal?.toString();
        if (id.isEmpty || val == null) continue;
        allSeqs[id] = e['sequence']?.toString() ?? '';
        allTargets[id] = val;
      }

      // 1. Cluster HBI does not depend on the split. For new clusterings, its clusters are needed
      // for the preview split, so it has to finish first
      final datasetHash = '${_selectedDatabaseType?.toString() ?? 'default'}_${entities.length}';
      final clusterFuture = api.clusterHbi(
        datasetHash: datasetHash,
        sequenceData: allSeqs,
        targetData: allTargets,
        sequenceIdentityThreshold: _clusteringThreshold,
        isNumeric: isNumeric,
        iterations: 30,
      );
      if (_method == SplitSetGenerationMethod.newCluster) {
        final clusters = _toClusterMap(await clusterFuture);
        if (isOutdated()) return;
        _computedClusters = clusters;
      }

      // 2. Compute the partition mapping for every seed
      final splits = <int, (List<String>, List<String>)>{};
      for (int seed = 0; seed < _numSeeds; seed++) {
        final splitMapping = _computePreviewSplit(seed: seed);
        if (splitMapping == null) {
          setState(() => _isEvaluatingHBI = false);
          return;
        }
        splits[seed] = _trainAndQueryIds(splitMapping, allSeqs.keys);
      }

      // 3. Split HBI (train → test) for all seeds in a single request
      final scanResponse = await api.splitHbiSeedScan(
        sequences: allSeqs,
        labels: allTargets,
        splits: splits,
        isNumeric: isNumeric,
        evalueCutoff: _eValueThreshold,
      );
      final clusterResponse = await clusterFuture;

      if (isOutdated()) return;
      final scanResults = scanResponse?.results.toList();
      setState(() {
        _seedScanResults = scanResults;
        _seed = _medianSeed(scanResults, isNumeric) ?? _seed;
        _clusterHbiMetrics = clusterResponse?.metrics.toList();
        _computedClusters = _toClusterMap(clusterResponse);
        _isEvaluatingHBI = false;
      });
    } catch (e) {
      if (isOutdated()) return;
      setState(() {
        _isEvaluatingHBI = false;
        _hbiErrorMessage = 'Failed to compute HBI leakage: $e';
      });
    }
  }

  /// Train ids and evaluated (query) ids of a split, restricted to [labelledIds]
  (List<String>, List<String>) _trainAndQueryIds(Map<String, SplitSet> splitMapping, Iterable<String> labelledIds) {
    final trainIds = <String>[];
    final queryIds = <String>[];
    for (final id in labelledIds) {
      final split = splitMapping[id];
      if (split == SplitSet.train || split == _subsplitSource) {
        trainIds.add(id);
      } else if (split == SplitSet.test || split == _subsplitTarget) {
        queryIds.add(id);
      }
    }
    return (trainIds, queryIds);
  }

  /// The metric shown for HBI values: accuracy for classification, RMSE for regression
  BootstrappedMetric? _primaryMetric(Iterable<BootstrappedMetric>? metrics, bool isNumeric) {
    final name = isNumeric ? 'rmse' : 'accuracy';
    return metrics?.where((metric) => metric.name == name).firstOrNull;
  }

  /// Seed -> mean split HBI of all scanned seeds
  Map<int, double> _seedHbiValues(List<SeedHBIResult>? results, bool isNumeric) {
    return {
      for (final result in results ?? <SeedHBIResult>[])
        if (_primaryMetric(result.metrics, isNumeric) case final metric?) result.seed: metric.mean.toDouble(),
    };
  }

  /// Seed whose split HBI is closest to the median over all scanned seeds
  int? _medianSeed(List<SeedHBIResult>? results, bool isNumeric) {
    final values = _seedHbiValues(results, isNumeric);
    if (values.isEmpty) return null;
    final sorted = values.values.toList()..sort();
    final mid = sorted.length ~/ 2;
    final median = sorted.length.isOdd ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2;
    return values.entries.reduce((a, b) => (a.value - median).abs() <= (b.value - median).abs() ? a : b).key;
  }

  Map<String, List<String>>? _toClusterMap(ClusterHBIResponse? response) {
    return response?.clusters.toMap().map((k, v) => MapEntry(k, v.toList()));
  }

  int? getDatabaseLength() {
    return context.read<BiocentralDatabaseRepository>().getFromType(_selectedDatabaseType)?.entitiesAsMaps().length;
  }

  @override
  void initState() {
    super.initState();
    final availableSourceSets = getAvailableSourceSets();
    _availableSourceSets.clear();
    _availableSourceSets.addAll(availableSourceSets);
    _selectedDatabaseLength = getDatabaseLength();
  }

  SplitDataCommand? collectCommand() {
    final database = context.read<BiocentralDatabaseRepository>().getFromType(_selectedDatabaseType);
    final apiRepository = context.read<BiocentralAPIRepository>();
    if (_mode == null || database == null) {
      return null;
    }
    if (_method == SplitSetGenerationMethod.existingCluster && _selectedClusterColumn == null) {
      return null;
    }
    if (_mode == SplitSetGenerationMode.generateNew) {
      if (_method != null && _splitRatio != null) {
        return SplitDataCommand(
          database: database,
          apiRepository: apiRepository,
          mode: _mode!,
          method: _method!,
          splitRatio: _splitRatio!,
          seed: _seed,
          selectedClusterColumn: _selectedClusterColumn,
          clusteringThreshold: _clusteringThreshold,
        );
      }
    } else {
      if (_selectedSetColumn != null && _subsplitSource != null && _subsplitTarget == null) {
        return SplitDataCommand(
          database: database,
          apiRepository: apiRepository,
          mode: _mode!,
          method: _method!,
          splitRatio: _splitRatio!,
          seed: _seed,
          selectedSetColumn: _selectedSetColumn,
          subsplitSource: _subsplitSource,
          subsplitTarget: _subsplitTarget,
          selectedClusterColumn: _selectedClusterColumn,
          clusteringThreshold: _clusteringThreshold,
        );
      }
    }
    return null;
  }

  void applyConfiguratorHierarchy() {
    // TODO Consider previous mode here
    if (_mode == null) {
      _selectedSetColumn = null;
    }

    if (_mode != SplitSetGenerationMode.subsplitExisting) {
      _subsplitSource = null;
      _subsplitTarget = null;
      _selectedSetColumn = null;
    }
    if (_selectedSetColumn == null) {
      _subsplitSource = null;
      _subsplitTarget = null;
    }
    if (_subsplitSource == null) {
      _subsplitTarget = null;
    }
    if (_method == null) {
      _splitRatio = null;
    }
    if (_mode != null && _method != null) {
      _splitRatio ??= SplitRatio.defaultForMode(_mode!);
    }
    if (_method != SplitSetGenerationMethod.existingCluster) {
      _selectedClusterColumn = null;
    }
    triggerAutoEvaluation();
  }

  Map<BiocentralDatabaseColumn, Set<SplitSet>> getAvailableSourceSets() {
    Set<BiocentralDatabaseColumn>? existingSetColumns;
    final database = context.read<BiocentralDatabaseRepository>().getFromType(_selectedDatabaseType);
    if (database != null) {
      existingSetColumns = database.getSetColumns();
    }

    existingSetColumns ??= {};

    // Get available sets from the selected column for subsplitting
    final availableSourceSets = Map.fromEntries(
      existingSetColumns
          .map((column) => MapEntry(column, column.detectSplitSets()))
          .where((entry) => entry.value.length <= 2),
    );
    return availableSourceSets;
  }

  @override
  Widget build(BuildContext context) {
    return BiocentralCommandWidget(
      icon: const Icon(Icons.splitscreen_outlined),
      name: 'Split your data',
      description: 'Split your data into robust sets (e.g. train/val/test) for model training',
      executeButtonLabel: 'Split',
      parameterSelection: buildParameterSelection,
      collectCommand: collectCommand,
      visualizeResult: BiocentralCommandWidget.visualizeDatabaseResult,
      commandAvailability: BiocentralCommandAvailability.always(),
    );
  }

  Widget buildParameterSelection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          withCondition(condition: true, childFunction: buildDatasetSelection),
          withCondition(condition: _selectedDatabaseType != null, childFunction: buildModeSelection),
          withCondition(
            condition: _mode == SplitSetGenerationMode.subsplitExisting && _availableSourceSets.isNotEmpty,
            childFunction: buildExistingSetSelection,
          ),
          withCondition(
            condition: _mode == SplitSetGenerationMode.subsplitExisting && _selectedSetColumn != null,
            childFunction: buildSourceSetSelection,
          ),
          withCondition(
            condition: _mode == SplitSetGenerationMode.subsplitExisting &&
                _selectedSetColumn != null &&
                _subsplitSource != null,
            childFunction: buildNewSetNameSelection,
          ),
          withCondition(
            condition: _mode == SplitSetGenerationMode.generateNew || _subsplitTarget != null,
            childFunction: buildMethodSelection,
          ),
          withCondition(
            condition: _method == SplitSetGenerationMethod.existingCluster,
            childFunction: buildClusterColumnSelection,
          ),
          withCondition(
            condition: _method == SplitSetGenerationMethod.newCluster,
            childFunction: buildNewClusterConfig,
          ),
          withCondition(
            condition: _method != null,
            childFunction: buildTargetColumnSelection,
          ),
          withCondition(
            condition: _method != null,
            childFunction: buildSeedCountSlider,
          ),
          withCondition(condition: _method != null, childFunction: buildRatioSlider),
          withCondition(condition: _method != null, childFunction: buildHbiPreviewCard),
        ].withPadding(
          const Padding(
            padding: EdgeInsetsGeometry.all(8.0),
          ),
        ),
      ),
    );
  }

  Widget buildDatasetSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Do you want to generate a set for proteins or protein-protein interactions?'),
        BiocentralEntityTypeSelection(
          initialValue: _selectedDatabaseType,
          onChangedCallback: (Type? selected) {
            final availableSourceSets = getAvailableSourceSets();
            setState(() {
              _selectedDatabaseType = selected;
              _selectedDatabaseLength = getDatabaseLength();
              _computedClusters = null;
              _availableSourceSets.clear();
              _availableSourceSets.addAll(availableSourceSets);
              applyConfiguratorHierarchy();
            });
          },
        ),
      ],
    );
  }

  Widget buildModeSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Do you want to create new splits or subsplit an existing set?'),
        Row(
          children: [
            Expanded(
              child: BiocentralDropdownMenu<SplitSetGenerationMode>(
                label: const Text('Mode..'),
                initialSelection: _mode,
                dropdownMenuEntries: [
                  const DropdownMenuEntry<SplitSetGenerationMode>(
                    value: SplitSetGenerationMode.generateNew,
                    label: 'Create new splits',
                  ),
                  DropdownMenuEntry<SplitSetGenerationMode>(
                    value: SplitSetGenerationMode.subsplitExisting,
                    label: 'Subsplit existing set',
                    enabled: _availableSourceSets.isNotEmpty,
                  ),
                ],
                onSelected: (SplitSetGenerationMode? value) {
                  setState(() {
                    _mode = value;
                    applyConfiguratorHierarchy();
                  });
                },
              ),
            ),
          ],
        ),
        if (_mode == SplitSetGenerationMode.subsplitExisting && _availableSourceSets.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'No existing set columns found in the database.',
              style: TextStyle(color: Colors.orange),
            ),
          ),
      ],
    );
  }

  Widget buildExistingSetSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Select the existing set column to subsplit:'),
        Row(
          children: [
            Expanded(
              child: BiocentralDropdownMenu<BiocentralDatabaseColumn>(
                label: const Text('Existing set column..'),
                dropdownMenuEntries: _availableSourceSets.keys
                    .map(
                      (BiocentralDatabaseColumn column) =>
                          DropdownMenuEntry<BiocentralDatabaseColumn>(value: column, label: column.name),
                    )
                    .toList(),
                onSelected: (BiocentralDatabaseColumn? value) {
                  setState(() {
                    _selectedSetColumn = value;
                    applyConfiguratorHierarchy();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSourceSetSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Select which set to split:'),
        const SizedBox(height: 6),
        BiocentralDropdownMenu<SplitSet>(
          label: const Text('Source set..'),
          dropdownMenuEntries: (_availableSourceSets[_selectedSetColumn] ?? {})
              .where((SplitSet set) => set.isPartition)
              .map((SplitSet set) => DropdownMenuEntry<SplitSet>(value: set, label: set.name))
              .toList(),
          onSelected: (SplitSet? value) {
            setState(() {
              _subsplitSource = value;
              applyConfiguratorHierarchy();
            });
          },
        ),
      ],
    );
  }

  Widget buildNewSetNameSelection() {
    final List<SplitSet> availableNames =
        SplitSet.values.where((set) => set != _subsplitSource && set.isPartition).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Select the name for the new subsplit:'),
        const SizedBox(height: 6),
        BiocentralDropdownMenu<SplitSet>(
          label: const Text('New set name..'),
          dropdownMenuEntries:
              availableNames.map((SplitSet set) => DropdownMenuEntry<SplitSet>(value: set, label: set.name)).toList(),
          onSelected: (SplitSet? value) {
            setState(() {
              _subsplitTarget = value;
              applyConfiguratorHierarchy();
            });
          },
        ),
      ],
    );
  }

  Widget buildMethodSelection() {
    final clusterCols = getDiscoveredClusterColumns();
    final hasClusters = clusterCols.isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Which kind of set generation method should be applied?'),
        Row(
          children: [
            Expanded(
              child: BiocentralDropdownMenu<SplitSetGenerationMethod>(
                label: const Text('Method..'),
                initialSelection: _method,
                dropdownMenuEntries: _availableMethods.map((method) {
                  switch (method) {
                    case SplitSetGenerationMethod.random:
                      return const DropdownMenuEntry(
                        value: SplitSetGenerationMethod.random,
                        label: 'Random Split',
                      );
                    case SplitSetGenerationMethod.existingCluster:
                      return DropdownMenuEntry(
                        value: SplitSetGenerationMethod.existingCluster,
                        label: 'Use Existing Clustering',
                        enabled: hasClusters,
                      );
                    case SplitSetGenerationMethod.newCluster:
                      return const DropdownMenuEntry(
                        value: SplitSetGenerationMethod.newCluster,
                        label: 'Create New Clustering',
                      );
                  }
                }).toList(),
                onSelected: (SplitSetGenerationMethod? value) => setState(() {
                  _method = value;
                  if (_method == SplitSetGenerationMethod.existingCluster && clusterCols.isNotEmpty) {
                    _selectedClusterColumn = clusterCols.first;
                  } else {
                    _selectedClusterColumn = null;
                  }
                  applyConfiguratorHierarchy();
                }),
              ),
            ),
          ],
        ),
        if (!hasClusters)
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              'No cluster columns found. Run MMseqs2 in the Proteins tab first.',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget buildClusterColumnSelection() {
    final clusterCols = getDiscoveredClusterColumns();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Select the cluster column to use for grouping:'),
        const SizedBox(height: 6),
        BiocentralDropdownMenu<String>(
          label: const Text('Cluster Column..'),
          initialSelection: _selectedClusterColumn,
          dropdownMenuEntries: clusterCols.map((col) => DropdownMenuEntry<String>(value: col, label: col)).toList(),
          onSelected: (String? value) => setState(() {
            _selectedClusterColumn = value;
            triggerAutoEvaluation();
          }),
        ),
      ],
    );
  }

  Widget buildNewClusterConfig() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sequence Identity Threshold: ${(_clusteringThreshold * 100).toInt()}%',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Slider(
          value: _clusteringThreshold,
          min: 0.1,
          divisions: 18,
          label: '${(_clusteringThreshold * 100).toInt()}%',
          onChanged: (double val) {
            setState(() {
              _clusteringThreshold = (val * 100).round() / 100;
              triggerAutoEvaluation();
            });
          },
        ),
        const Text(
          'MMseqs2 will cluster sequences before partitioning.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  dynamic _getEntityAttribute(Map<String, dynamic> entity, String columnName) {
    if (entity.containsKey(columnName)) return entity[columnName];
    final attributes = entity['attributes'] as Map<String, dynamic>?;
    return attributes?[columnName];
  }

  bool _isColumnNumeric(String columnName) {
    final database = context.read<BiocentralDatabaseRepository>().getFromType(_selectedDatabaseType);
    if (database == null) return false;

    final sample = database.entitiesAsMaps();
    int nonNullCount = 0;

    for (final entity in sample) {
      final rawVal = _getEntityAttribute(entity, columnName);
      if (rawVal == null) continue;
      final str = rawVal.toString().trim();
      if (str.isEmpty || str.toLowerCase() == 'null' || str.toLowerCase() == 'nan') continue;

      nonNullCount++;
      if (double.tryParse(str) == null) {
        return false; // Found a text label -> Classification
      }
    }
    // Only numeric if we actually parsed numbers
    return nonNullCount > 0;
  }

  String _calculateRandomBaseline() {
    if (_selectedTargetColumn == null || _method == null || _splitRatio == null) {
      return 'Select target';
    }
    final database = context.read<BiocentralDatabaseRepository>().getFromType(_selectedDatabaseType);
    if (database == null) return 'N/A';

    final entities = database.entitiesAsMaps();
    if (entities.isEmpty) return 'N/A';

    final splitMapping = _computePreviewSplit();
    if (splitMapping == null) return 'N/A';

    final isNumeric = _isColumnNumeric(_selectedTargetColumn!);
    final trainEntities = <Map<String, dynamic>>[];
    final testEntities = <Map<String, dynamic>>[];

    for (final e in entities) {
      final id = e['id']?.toString() ?? '';
      final assignedSet = splitMapping[id];
      if (assignedSet == SplitSet.train || assignedSet == _subsplitSource) {
        trainEntities.add(e);
      } else if (assignedSet == SplitSet.test || assignedSet == _subsplitTarget) {
        testEntities.add(e);
      }
      // SplitSet.member is omitted from baseline prior calculation
    }

    if (trainEntities.isEmpty || testEntities.isEmpty) return 'N/A';

    if (isNumeric) {
      final trainVals = trainEntities
          .map((e) => double.tryParse(_getEntityAttribute(e, _selectedTargetColumn!)?.toString() ?? ''))
          .whereType<double>()
          .toList();
      final testVals = testEntities
          .map((e) => double.tryParse(_getEntityAttribute(e, _selectedTargetColumn!)?.toString() ?? ''))
          .whereType<double>()
          .toList();

      if (trainVals.isEmpty || testVals.isEmpty) return 'N/A';
      final trainMean = trainVals.reduce((a, b) => a + b) / trainVals.length;
      final testMse = testVals.map((v) => pow(v - trainMean, 2)).reduce((a, b) => a + b) / testVals.length;
      return 'RMSE: ${sqrt(testMse).toStringAsFixed(3)}';
    } else {
      final trainCounts = <String, int>{};
      for (final e in trainEntities) {
        final raw = _getEntityAttribute(e, _selectedTargetColumn!);
        if (raw == null) continue;
        final val = raw.toString().trim();
        if (val.isNotEmpty && val.toLowerCase() != 'null') {
          trainCounts[val] = (trainCounts[val] ?? 0) + 1;
        }
      }
      if (trainCounts.isEmpty) return 'N/A';

      final majorityClass = trainCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

      int testCorrect = 0;
      int testTotal = 0;
      for (final e in testEntities) {
        final raw = _getEntityAttribute(e, _selectedTargetColumn!);
        if (raw == null) continue;
        final val = raw.toString().trim();
        if (val.isNotEmpty && val.toLowerCase() != 'null') {
          testTotal++;
          if (val == majorityClass) testCorrect++;
        }
      }

      if (testTotal == 0) return 'N/A';
      final acc = (testCorrect / testTotal) * 100;
      return 'Acc: ${acc.toStringAsFixed(1)}%';
    }
  }

  String _formatValue(num value, bool isNumeric) {
    return isNumeric ? value.toStringAsFixed(3) : '${(value * 100).toStringAsFixed(1)}%';
  }

  String _formatMetric(BootstrappedMetric? metric, bool isNumeric) {
    if (metric == null) return 'N/A';
    return '${_formatValue(metric.mean, isNumeric)} '
        '[${_formatValue(metric.lower, isNumeric)}, ${_formatValue(metric.upper, isNumeric)}]';
  }

  Widget buildHbiPreviewCard() {
    final isSelected = _selectedTargetColumn != null;
    final isNumeric = isSelected ? _isColumnNumeric(_selectedTargetColumn!) : false;
    final baseline = _calculateRandomBaseline();

    final splitMetric = _primaryMetric(_splitHbiMetrics, isNumeric);
    final clusterMetric = _primaryMetric(_clusterHbiMetrics, isNumeric);
    final seedHbiValues = _seedHbiValues(_seedScanResults, isNumeric);

    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.blueGrey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, size: 18, color: Colors.blueGrey),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Homology & Baseline Leakage',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isEvaluatingHBI)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isNumeric ? 'RMSE' : 'Accuracy',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Vertical stack of metrics for sidebar fit
          _buildMetricRow(
            title: 'Random Baseline',
            value: isSelected ? baseline : 'Select target',
            subtitle: isNumeric ? 'Mean Dummy Prior' : 'Majority Class Prior',
          ),
          const Divider(height: 14),
          _buildMetricRow(
            title: 'Split HBI (Train → Test)',
            value: _isEvaluatingHBI
                ? 'Updating...'
                : (isSelected ? _formatMetric(splitMetric, isNumeric) : 'Select target'),
            subtitle: 'Cross-split homology (easy_search), seed $_seed',
            isPending: _isEvaluatingHBI,
          ),
          if (!_isEvaluatingHBI && isSelected && seedHbiValues.length > 1) ...[
            const SizedBox(height: 8),
            _buildSeedDistribution(seedHbiValues, isNumeric),
          ],
          const Divider(height: 14),
          _buildMetricRow(
            title: 'Cluster HBI (Intra-Cluster)',
            value: _isEvaluatingHBI
                ? 'Updating...'
                : (isSelected ? _formatMetric(clusterMetric, isNumeric) : 'Select target'),
            subtitle: 'Cluster rep → member transfer',
            isPending: _isEvaluatingHBI,
          ),
          if (_computedClusters != null && _computedClusters!.isNotEmpty) ...[
            const Divider(height: 20),
            const Text(
              'Cluster Size Distribution',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            _buildClusterHistogram(_computedClusters!),
          ],
          if (_hbiErrorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _hbiErrorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClusterHistogram(Map<String, List<String>> clusters) {
    // Generate cluster size frequency bins: 1, 2-5, 6-10, 11-20, >20
    final sizes = clusters.values.map((m) => m.length).toList();
    final bins = <String, int>{
      '1': sizes.where((s) => s == 1).length,
      '2–5': sizes.where((s) => s >= 2 && s <= 5).length,
      '6–10': sizes.where((s) => s >= 6 && s <= 10).length,
      '11–20': sizes.where((s) => s >= 11 && s <= 20).length,
      '>20': sizes.where((s) => s > 20).length,
    };
    final maxCount = bins.values.fold<int>(1, (prev, curr) => curr > prev ? curr : prev);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: bins.entries.map((entry) {
        final double barHeight = (entry.value / maxCount) * 50.0;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${entry.value}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Container(
                  height: barHeight.clamp(4.0, 50.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 4),
                Text(entry.key, style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricRow({
    required String title,
    required String value,
    required String subtitle,
    bool isPending = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isPending ? Colors.orange.shade700 : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 9, color: Colors.grey),
        ),
      ],
    );
  }

  Widget buildTargetColumnSelection() {
    final targets = getAvailableTargetColumns();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Target Column (for HBI evaluation):'),
        const SizedBox(height: 6),
        BiocentralDropdownMenu<String>(
          label: const Text('Target Column..'),
          initialSelection: _selectedTargetColumn,
          dropdownMenuEntries: targets.map((col) => DropdownMenuEntry<String>(value: col, label: col)).toList(),
          onSelected: (String? value) => setState(() {
            _selectedTargetColumn = value;
            triggerAutoEvaluation();
          }),
        ),
      ],
    );
  }

  Widget buildSeedCountSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Seeds to compare: $_numSeeds',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Slider(
          value: _numSeeds.toDouble(),
          min: 5,
          max: 30,
          divisions: 25,
          label: '$_numSeeds',
          onChanged: (double val) {
            setState(() {
              _numSeeds = val.round();
              triggerAutoEvaluation();
            });
          },
        ),
        const Text(
          'The split HBI is computed for each seed, and the seed closest to the median is used for the split.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  /// Split HBI of every scanned seed as bars sorted by value. Tapping a bar selects that seed
  Widget _buildSeedDistribution(Map<int, double> seedHbiValues, bool isNumeric) {
    final sorted = seedHbiValues.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
    final minValue = sorted.first.value;
    final range = sorted.last.value - minValue;
    final isMedianSeed = _medianSeed(_seedScanResults, isNumeric) == _seed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: sorted.map((entry) {
              final double barHeight = range == 0 ? 25.0 : 6.0 + (entry.value - minValue) / range * 44.0;
              return Expanded(
                child: Tooltip(
                  message: 'Seed ${entry.key}: ${_formatValue(entry.value, isNumeric)}',
                  child: GestureDetector(
                    onTap: () => setState(() => _seed = entry.key),
                    child: Container(
                      height: barHeight,
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                        color: entry.key == _seed ? Colors.orange.shade700 : Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Seed $_seed ${isMedianSeed ? '(median)' : '(manually selected)'} of ${sorted.length} seeds, '
          'range ${_formatValue(minValue, isNumeric)} – ${_formatValue(sorted.last.value, isNumeric)}. '
          'Tap a bar to use another seed.',
          style: const TextStyle(fontSize: 9, color: Colors.grey),
        ),
      ],
    );
  }

  Widget buildRatioSlider() {
    final isSubsplit = _mode == SplitSetGenerationMode.subsplitExisting;
    final splitMapping = _computePreviewSplit();
    final counts = splitMapping != null ? SetGenerator.countSets(splitMapping) : null;
    final displayedSets = isSubsplit ? [_subsplitSource!, _subsplitTarget!] : [SplitSet.train, SplitSet.val, SplitSet.test];
    final displayedCounts = counts != null ? displayedSets.map((set) => counts[set]!).toList() : null;

    Widget slider;
    if (isSubsplit) {
      slider = BiocentralRatioSlider(
        ratio1: _splitRatio!.r1,
        totalN: _selectedSetColumn?.length,
        counts: displayedCounts,
        labels: [_subsplitSource!.name, _subsplitTarget!.name],
        colors: const [
          Colors.blue,
          Colors.black,
        ],
        onChanged: (ratios) {
          setState(() {
            _splitRatio = SplitRatio.fromRecord(ratios);
            applyConfiguratorHierarchy();
            triggerAutoEvaluation();
          });
        },
      );
    } else {
      slider = BiocentralRatioSlider(
        ratio1: _splitRatio!.r1,
        ratio2: _splitRatio?.r2,
        totalN: _selectedDatabaseLength,
        counts: displayedCounts,
        labels: const ['Training', 'Validation', 'Test'],
        colors: const [Colors.blue, Colors.black, Colors.blueGrey],
        onChanged: (ratios) {
          setState(() {
            _splitRatio = SplitRatio.fromRecord(ratios);
            applyConfiguratorHierarchy();
          });
        },
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Select the size of the subsplit:'),
        slider,
        if (counts != null) ..._buildSplitSizeHints(counts, testSet: displayedSets.last, isSubsplit: isSubsplit),
      ],
    );
  }

  List<Widget> _buildSplitSizeHints(Map<SplitSet, int> counts, {required SplitSet testSet, required bool isSubsplit}) {
    const hintStyle = TextStyle(fontSize: 12, color: Colors.grey);
    final isClusterSplit = _method != SplitSetGenerationMethod.random;
    final unitName = isClusterSplit ? 'cluster representatives' : 'sequences';
    final nUnits = counts.entries.where((entry) => entry.key.isPartition).fold(0, (sum, entry) => sum + entry.value);
    final nTest = counts[testSet]!;
    final recommended = SplitRatio.recommendFor(nUnits, minTest: _minTestSequences);

    return [
      if (isClusterSplit && counts[SplitSet.member]! > 0)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '+ ${counts[SplitSet.member]} cluster members (not assigned to a set)',
            style: hintStyle,
          ),
        ),
      if (nTest < _minTestSequences)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '${testSet.name} set: $nTest $unitName (${(nTest / max(nUnits, 1) * 100).round()}%), '
            'at least $_minTestSequences recommended for reliable evaluation.',
            style: const TextStyle(color: Colors.orange, fontSize: 12),
          ),
        ),
      if (!isSubsplit)
        Row(
          children: [
            Expanded(
              child: Text(
                'Recommended for $nUnits $unitName: ${_formatRatio(recommended)}',
                style: hintStyle,
              ),
            ),
            TextButton(
              onPressed: () => setState(() {
                _splitRatio = recommended;
                applyConfiguratorHierarchy();
              }),
              child: const Text('Apply'),
            ),
          ],
        ),
    ];
  }

  String _formatRatio(SplitRatio ratio) {
    final (train, val, test) = ratio.full;
    String percent(double r) => (r * 100).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    return '${percent(train)}/${percent(val)}/${percent(test)}';
  }
}
