// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_hbi_seed_scan_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SplitHBISeedScanResponse extends SplitHBISeedScanResponse {
  @override
  final BuiltList<SeedHBIResult> results;

  factory _$SplitHBISeedScanResponse(
          [void Function(SplitHBISeedScanResponseBuilder)? updates]) =>
      (SplitHBISeedScanResponseBuilder()..update(updates))._build();

  _$SplitHBISeedScanResponse._({required this.results}) : super._();
  @override
  SplitHBISeedScanResponse rebuild(
          void Function(SplitHBISeedScanResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SplitHBISeedScanResponseBuilder toBuilder() =>
      SplitHBISeedScanResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SplitHBISeedScanResponse && results == other.results;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, results.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SplitHBISeedScanResponse')
          ..add('results', results))
        .toString();
  }
}

class SplitHBISeedScanResponseBuilder
    implements
        Builder<SplitHBISeedScanResponse, SplitHBISeedScanResponseBuilder> {
  _$SplitHBISeedScanResponse? _$v;

  ListBuilder<SeedHBIResult>? _results;
  ListBuilder<SeedHBIResult> get results =>
      _$this._results ??= ListBuilder<SeedHBIResult>();
  set results(ListBuilder<SeedHBIResult>? results) => _$this._results = results;

  SplitHBISeedScanResponseBuilder() {
    SplitHBISeedScanResponse._defaults(this);
  }

  SplitHBISeedScanResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _results = $v.results.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SplitHBISeedScanResponse other) {
    _$v = other as _$SplitHBISeedScanResponse;
  }

  @override
  void update(void Function(SplitHBISeedScanResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SplitHBISeedScanResponse build() => _build();

  _$SplitHBISeedScanResponse _build() {
    _$SplitHBISeedScanResponse _$result;
    try {
      _$result = _$v ??
          _$SplitHBISeedScanResponse._(
            results: results.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'results';
        results.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SplitHBISeedScanResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
