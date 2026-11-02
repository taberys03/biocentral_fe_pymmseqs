//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:biocentral_api/src/model/seed_hbi_result.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'split_hbi_seed_scan_response.g.dart';

/// SplitHBISeedScanResponse
///
/// Properties:
/// * [results] - Split HBI result per seed
@BuiltValue()
abstract class SplitHBISeedScanResponse implements Built<SplitHBISeedScanResponse, SplitHBISeedScanResponseBuilder> {
  /// Split HBI result per seed
  @BuiltValueField(wireName: r'results')
  BuiltList<SeedHBIResult> get results;

  SplitHBISeedScanResponse._();

  factory SplitHBISeedScanResponse([void updates(SplitHBISeedScanResponseBuilder b)]) = _$SplitHBISeedScanResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SplitHBISeedScanResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SplitHBISeedScanResponse> get serializer => _$SplitHBISeedScanResponseSerializer();
}

class _$SplitHBISeedScanResponseSerializer implements PrimitiveSerializer<SplitHBISeedScanResponse> {
  @override
  final Iterable<Type> types = const [SplitHBISeedScanResponse, _$SplitHBISeedScanResponse];

  @override
  final String wireName = r'SplitHBISeedScanResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SplitHBISeedScanResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'results';
    yield serializers.serialize(
      object.results,
      specifiedType: const FullType(BuiltList, [FullType(SeedHBIResult)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SplitHBISeedScanResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SplitHBISeedScanResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'results':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SeedHBIResult)]),
          ) as BuiltList<SeedHBIResult>;
          result.results.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SplitHBISeedScanResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SplitHBISeedScanResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


