//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:biocentral_api/src/model/bootstrapped_metric.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'seed_hbi_result.g.dart';

/// SeedHBIResult
///
/// Properties:
/// * [seed] - Seed that generated the split
/// * [metrics] - Bootstrapped evaluation metrics
/// * [hitsFound] - Number of queries with homologous hits in train
/// * [evaluatedQueries] - Number of queries successfully evaluated
@BuiltValue()
abstract class SeedHBIResult implements Built<SeedHBIResult, SeedHBIResultBuilder> {
  /// Seed that generated the split
  @BuiltValueField(wireName: r'seed')
  int get seed;

  /// Bootstrapped evaluation metrics
  @BuiltValueField(wireName: r'metrics')
  BuiltList<BootstrappedMetric> get metrics;

  /// Number of queries with homologous hits in train
  @BuiltValueField(wireName: r'hits_found')
  int get hitsFound;

  /// Number of queries successfully evaluated
  @BuiltValueField(wireName: r'evaluated_queries')
  int get evaluatedQueries;

  SeedHBIResult._();

  factory SeedHBIResult([void updates(SeedHBIResultBuilder b)]) = _$SeedHBIResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SeedHBIResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SeedHBIResult> get serializer => _$SeedHBIResultSerializer();
}

class _$SeedHBIResultSerializer implements PrimitiveSerializer<SeedHBIResult> {
  @override
  final Iterable<Type> types = const [SeedHBIResult, _$SeedHBIResult];

  @override
  final String wireName = r'SeedHBIResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SeedHBIResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'seed';
    yield serializers.serialize(
      object.seed,
      specifiedType: const FullType(int),
    );
    yield r'metrics';
    yield serializers.serialize(
      object.metrics,
      specifiedType: const FullType(BuiltList, [FullType(BootstrappedMetric)]),
    );
    yield r'hits_found';
    yield serializers.serialize(
      object.hitsFound,
      specifiedType: const FullType(int),
    );
    yield r'evaluated_queries';
    yield serializers.serialize(
      object.evaluatedQueries,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SeedHBIResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SeedHBIResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'seed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seed = valueDes;
          break;
        case r'metrics':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BootstrappedMetric)]),
          ) as BuiltList<BootstrappedMetric>;
          result.metrics.replace(valueDes);
          break;
        case r'hits_found':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.hitsFound = valueDes;
          break;
        case r'evaluated_queries':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.evaluatedQueries = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SeedHBIResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SeedHBIResultBuilder();
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


