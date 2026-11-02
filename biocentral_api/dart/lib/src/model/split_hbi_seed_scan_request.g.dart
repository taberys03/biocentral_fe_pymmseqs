// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_hbi_seed_scan_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SplitHBISeedScanRequest extends SplitHBISeedScanRequest {
  @override
  final BuiltMap<String, String> sequences;
  @override
  final BuiltMap<String, JsonObject?> labels;
  @override
  final BuiltList<SeedSplit> splits;
  @override
  final num? evalueCutoff;
  @override
  final num? minSeqId;
  @override
  final bool? isNumeric;
  @override
  final int? iterations;

  factory _$SplitHBISeedScanRequest(
          [void Function(SplitHBISeedScanRequestBuilder)? updates]) =>
      (SplitHBISeedScanRequestBuilder()..update(updates))._build();

  _$SplitHBISeedScanRequest._(
      {required this.sequences,
      required this.labels,
      required this.splits,
      this.evalueCutoff,
      this.minSeqId,
      this.isNumeric,
      this.iterations})
      : super._();
  @override
  SplitHBISeedScanRequest rebuild(
          void Function(SplitHBISeedScanRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SplitHBISeedScanRequestBuilder toBuilder() =>
      SplitHBISeedScanRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SplitHBISeedScanRequest &&
        sequences == other.sequences &&
        labels == other.labels &&
        splits == other.splits &&
        evalueCutoff == other.evalueCutoff &&
        minSeqId == other.minSeqId &&
        isNumeric == other.isNumeric &&
        iterations == other.iterations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequences.hashCode);
    _$hash = $jc(_$hash, labels.hashCode);
    _$hash = $jc(_$hash, splits.hashCode);
    _$hash = $jc(_$hash, evalueCutoff.hashCode);
    _$hash = $jc(_$hash, minSeqId.hashCode);
    _$hash = $jc(_$hash, isNumeric.hashCode);
    _$hash = $jc(_$hash, iterations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SplitHBISeedScanRequest')
          ..add('sequences', sequences)
          ..add('labels', labels)
          ..add('splits', splits)
          ..add('evalueCutoff', evalueCutoff)
          ..add('minSeqId', minSeqId)
          ..add('isNumeric', isNumeric)
          ..add('iterations', iterations))
        .toString();
  }
}

class SplitHBISeedScanRequestBuilder
    implements
        Builder<SplitHBISeedScanRequest, SplitHBISeedScanRequestBuilder> {
  _$SplitHBISeedScanRequest? _$v;

  MapBuilder<String, String>? _sequences;
  MapBuilder<String, String> get sequences =>
      _$this._sequences ??= MapBuilder<String, String>();
  set sequences(MapBuilder<String, String>? sequences) =>
      _$this._sequences = sequences;

  MapBuilder<String, JsonObject?>? _labels;
  MapBuilder<String, JsonObject?> get labels =>
      _$this._labels ??= MapBuilder<String, JsonObject?>();
  set labels(MapBuilder<String, JsonObject?>? labels) =>
      _$this._labels = labels;

  ListBuilder<SeedSplit>? _splits;
  ListBuilder<SeedSplit> get splits =>
      _$this._splits ??= ListBuilder<SeedSplit>();
  set splits(ListBuilder<SeedSplit>? splits) => _$this._splits = splits;

  num? _evalueCutoff;
  num? get evalueCutoff => _$this._evalueCutoff;
  set evalueCutoff(num? evalueCutoff) => _$this._evalueCutoff = evalueCutoff;

  num? _minSeqId;
  num? get minSeqId => _$this._minSeqId;
  set minSeqId(num? minSeqId) => _$this._minSeqId = minSeqId;

  bool? _isNumeric;
  bool? get isNumeric => _$this._isNumeric;
  set isNumeric(bool? isNumeric) => _$this._isNumeric = isNumeric;

  int? _iterations;
  int? get iterations => _$this._iterations;
  set iterations(int? iterations) => _$this._iterations = iterations;

  SplitHBISeedScanRequestBuilder() {
    SplitHBISeedScanRequest._defaults(this);
  }

  SplitHBISeedScanRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequences = $v.sequences.toBuilder();
      _labels = $v.labels.toBuilder();
      _splits = $v.splits.toBuilder();
      _evalueCutoff = $v.evalueCutoff;
      _minSeqId = $v.minSeqId;
      _isNumeric = $v.isNumeric;
      _iterations = $v.iterations;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SplitHBISeedScanRequest other) {
    _$v = other as _$SplitHBISeedScanRequest;
  }

  @override
  void update(void Function(SplitHBISeedScanRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SplitHBISeedScanRequest build() => _build();

  _$SplitHBISeedScanRequest _build() {
    _$SplitHBISeedScanRequest _$result;
    try {
      _$result = _$v ??
          _$SplitHBISeedScanRequest._(
            sequences: sequences.build(),
            labels: labels.build(),
            splits: splits.build(),
            evalueCutoff: evalueCutoff,
            minSeqId: minSeqId,
            isNumeric: isNumeric,
            iterations: iterations,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sequences';
        sequences.build();
        _$failedField = 'labels';
        labels.build();
        _$failedField = 'splits';
        splits.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SplitHBISeedScanRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
