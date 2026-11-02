//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'seed_split.g.dart';

/// SeedSplit
///
/// Properties:
/// * [seed] - Seed that generated this split
/// * [trainIds] - Sequence IDs in the train split
/// * [queryIds] - Sequence IDs in the evaluated split (test/val)
@BuiltValue()
abstract class SeedSplit implements Built<SeedSplit, SeedSplitBuilder> {
  /// Seed that generated this split
  @BuiltValueField(wireName: r'seed')
  int get seed;

  /// Sequence IDs in the train split
  @BuiltValueField(wireName: r'train_ids')
  BuiltList<String> get trainIds;

  /// Sequence IDs in the evaluated split (test/val)
  @BuiltValueField(wireName: r'query_ids')
  BuiltList<String> get queryIds;

  SeedSplit._();

  factory SeedSplit([void updates(SeedSplitBuilder b)]) = _$SeedSplit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SeedSplitBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SeedSplit> get serializer => _$SeedSplitSerializer();
}

class _$SeedSplitSerializer implements PrimitiveSerializer<SeedSplit> {
  @override
  final Iterable<Type> types = const [SeedSplit, _$SeedSplit];

  @override
  final String wireName = r'SeedSplit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SeedSplit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'seed';
    yield serializers.serialize(
      object.seed,
      specifiedType: const FullType(int),
    );
    yield r'train_ids';
    yield serializers.serialize(
      object.trainIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'query_ids';
    yield serializers.serialize(
      object.queryIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SeedSplit object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SeedSplitBuilder result,
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
        case r'train_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.trainIds.replace(valueDes);
          break;
        case r'query_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.queryIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SeedSplit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SeedSplitBuilder();
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


