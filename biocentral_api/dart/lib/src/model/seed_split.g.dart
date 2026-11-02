// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seed_split.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SeedSplit extends SeedSplit {
  @override
  final int seed;
  @override
  final BuiltList<String> trainIds;
  @override
  final BuiltList<String> queryIds;

  factory _$SeedSplit([void Function(SeedSplitBuilder)? updates]) =>
      (SeedSplitBuilder()..update(updates))._build();

  _$SeedSplit._(
      {required this.seed, required this.trainIds, required this.queryIds})
      : super._();
  @override
  SeedSplit rebuild(void Function(SeedSplitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SeedSplitBuilder toBuilder() => SeedSplitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SeedSplit &&
        seed == other.seed &&
        trainIds == other.trainIds &&
        queryIds == other.queryIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, seed.hashCode);
    _$hash = $jc(_$hash, trainIds.hashCode);
    _$hash = $jc(_$hash, queryIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SeedSplit')
          ..add('seed', seed)
          ..add('trainIds', trainIds)
          ..add('queryIds', queryIds))
        .toString();
  }
}

class SeedSplitBuilder implements Builder<SeedSplit, SeedSplitBuilder> {
  _$SeedSplit? _$v;

  int? _seed;
  int? get seed => _$this._seed;
  set seed(int? seed) => _$this._seed = seed;

  ListBuilder<String>? _trainIds;
  ListBuilder<String> get trainIds =>
      _$this._trainIds ??= ListBuilder<String>();
  set trainIds(ListBuilder<String>? trainIds) => _$this._trainIds = trainIds;

  ListBuilder<String>? _queryIds;
  ListBuilder<String> get queryIds =>
      _$this._queryIds ??= ListBuilder<String>();
  set queryIds(ListBuilder<String>? queryIds) => _$this._queryIds = queryIds;

  SeedSplitBuilder() {
    SeedSplit._defaults(this);
  }

  SeedSplitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _seed = $v.seed;
      _trainIds = $v.trainIds.toBuilder();
      _queryIds = $v.queryIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SeedSplit other) {
    _$v = other as _$SeedSplit;
  }

  @override
  void update(void Function(SeedSplitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SeedSplit build() => _build();

  _$SeedSplit _build() {
    _$SeedSplit _$result;
    try {
      _$result = _$v ??
          _$SeedSplit._(
            seed: BuiltValueNullFieldError.checkNotNull(
                seed, r'SeedSplit', 'seed'),
            trainIds: trainIds.build(),
            queryIds: queryIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'trainIds';
        trainIds.build();
        _$failedField = 'queryIds';
        queryIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SeedSplit', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
