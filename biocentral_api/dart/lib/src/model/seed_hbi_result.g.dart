// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seed_hbi_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SeedHBIResult extends SeedHBIResult {
  @override
  final int seed;
  @override
  final BuiltList<BootstrappedMetric> metrics;
  @override
  final int hitsFound;
  @override
  final int evaluatedQueries;

  factory _$SeedHBIResult([void Function(SeedHBIResultBuilder)? updates]) =>
      (SeedHBIResultBuilder()..update(updates))._build();

  _$SeedHBIResult._(
      {required this.seed,
      required this.metrics,
      required this.hitsFound,
      required this.evaluatedQueries})
      : super._();
  @override
  SeedHBIResult rebuild(void Function(SeedHBIResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SeedHBIResultBuilder toBuilder() => SeedHBIResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SeedHBIResult &&
        seed == other.seed &&
        metrics == other.metrics &&
        hitsFound == other.hitsFound &&
        evaluatedQueries == other.evaluatedQueries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, seed.hashCode);
    _$hash = $jc(_$hash, metrics.hashCode);
    _$hash = $jc(_$hash, hitsFound.hashCode);
    _$hash = $jc(_$hash, evaluatedQueries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SeedHBIResult')
          ..add('seed', seed)
          ..add('metrics', metrics)
          ..add('hitsFound', hitsFound)
          ..add('evaluatedQueries', evaluatedQueries))
        .toString();
  }
}

class SeedHBIResultBuilder
    implements Builder<SeedHBIResult, SeedHBIResultBuilder> {
  _$SeedHBIResult? _$v;

  int? _seed;
  int? get seed => _$this._seed;
  set seed(int? seed) => _$this._seed = seed;

  ListBuilder<BootstrappedMetric>? _metrics;
  ListBuilder<BootstrappedMetric> get metrics =>
      _$this._metrics ??= ListBuilder<BootstrappedMetric>();
  set metrics(ListBuilder<BootstrappedMetric>? metrics) =>
      _$this._metrics = metrics;

  int? _hitsFound;
  int? get hitsFound => _$this._hitsFound;
  set hitsFound(int? hitsFound) => _$this._hitsFound = hitsFound;

  int? _evaluatedQueries;
  int? get evaluatedQueries => _$this._evaluatedQueries;
  set evaluatedQueries(int? evaluatedQueries) =>
      _$this._evaluatedQueries = evaluatedQueries;

  SeedHBIResultBuilder() {
    SeedHBIResult._defaults(this);
  }

  SeedHBIResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _seed = $v.seed;
      _metrics = $v.metrics.toBuilder();
      _hitsFound = $v.hitsFound;
      _evaluatedQueries = $v.evaluatedQueries;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SeedHBIResult other) {
    _$v = other as _$SeedHBIResult;
  }

  @override
  void update(void Function(SeedHBIResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SeedHBIResult build() => _build();

  _$SeedHBIResult _build() {
    _$SeedHBIResult _$result;
    try {
      _$result = _$v ??
          _$SeedHBIResult._(
            seed: BuiltValueNullFieldError.checkNotNull(
                seed, r'SeedHBIResult', 'seed'),
            metrics: metrics.build(),
            hitsFound: BuiltValueNullFieldError.checkNotNull(
                hitsFound, r'SeedHBIResult', 'hitsFound'),
            evaluatedQueries: BuiltValueNullFieldError.checkNotNull(
                evaluatedQueries, r'SeedHBIResult', 'evaluatedQueries'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'metrics';
        metrics.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SeedHBIResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
