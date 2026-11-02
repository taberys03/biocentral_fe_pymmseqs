//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:biocentral_api/src/model/seed_split.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'split_hbi_seed_scan_request.g.dart';

/// SplitHBISeedScanRequest
///
/// Properties:
/// * [sequences] - Map of sequence_id -> sequence for all split sequences
/// * [labels] - Map of sequence_id -> target label/value
/// * [splits] - One split per seed
/// * [evalueCutoff] - Maximum MMSeqs2 E-value threshold
/// * [minSeqId] - Minimum sequence identity threshold
/// * [isNumeric] - True for continuous regression targets, False for classification
/// * [iterations] - Bootstrap iterations performed
@BuiltValue()
abstract class SplitHBISeedScanRequest implements Built<SplitHBISeedScanRequest, SplitHBISeedScanRequestBuilder> {
  /// Map of sequence_id -> sequence for all split sequences
  @BuiltValueField(wireName: r'sequences')
  BuiltMap<String, String> get sequences;

  /// Map of sequence_id -> target label/value
  @BuiltValueField(wireName: r'labels')
  BuiltMap<String, JsonObject?> get labels;

  /// One split per seed
  @BuiltValueField(wireName: r'splits')
  BuiltList<SeedSplit> get splits;

  /// Maximum MMSeqs2 E-value threshold
  @BuiltValueField(wireName: r'evalue_cutoff')
  num? get evalueCutoff;

  /// Minimum sequence identity threshold
  @BuiltValueField(wireName: r'min_seq_id')
  num? get minSeqId;

  /// True for continuous regression targets, False for classification
  @BuiltValueField(wireName: r'is_numeric')
  bool? get isNumeric;

  /// Bootstrap iterations performed
  @BuiltValueField(wireName: r'iterations')
  int? get iterations;

  SplitHBISeedScanRequest._();

  factory SplitHBISeedScanRequest([void updates(SplitHBISeedScanRequestBuilder b)]) = _$SplitHBISeedScanRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SplitHBISeedScanRequestBuilder b) => b
      ..evalueCutoff = 10.0
      ..minSeqId = 0.0
      ..isNumeric = false
      ..iterations = 30;

  @BuiltValueSerializer(custom: true)
  static Serializer<SplitHBISeedScanRequest> get serializer => _$SplitHBISeedScanRequestSerializer();
}

class _$SplitHBISeedScanRequestSerializer implements PrimitiveSerializer<SplitHBISeedScanRequest> {
  @override
  final Iterable<Type> types = const [SplitHBISeedScanRequest, _$SplitHBISeedScanRequest];

  @override
  final String wireName = r'SplitHBISeedScanRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SplitHBISeedScanRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sequences';
    yield serializers.serialize(
      object.sequences,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    yield r'labels';
    yield serializers.serialize(
      object.labels,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'splits';
    yield serializers.serialize(
      object.splits,
      specifiedType: const FullType(BuiltList, [FullType(SeedSplit)]),
    );
    if (object.evalueCutoff != null) {
      yield r'evalue_cutoff';
      yield serializers.serialize(
        object.evalueCutoff,
        specifiedType: const FullType(num),
      );
    }
    if (object.minSeqId != null) {
      yield r'min_seq_id';
      yield serializers.serialize(
        object.minSeqId,
        specifiedType: const FullType(num),
      );
    }
    if (object.isNumeric != null) {
      yield r'is_numeric';
      yield serializers.serialize(
        object.isNumeric,
        specifiedType: const FullType(bool),
      );
    }
    if (object.iterations != null) {
      yield r'iterations';
      yield serializers.serialize(
        object.iterations,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SplitHBISeedScanRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SplitHBISeedScanRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sequences':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.sequences.replace(valueDes);
          break;
        case r'labels':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.labels.replace(valueDes);
          break;
        case r'splits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SeedSplit)]),
          ) as BuiltList<SeedSplit>;
          result.splits.replace(valueDes);
          break;
        case r'evalue_cutoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.evalueCutoff = valueDes;
          break;
        case r'min_seq_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.minSeqId = valueDes;
          break;
        case r'is_numeric':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isNumeric = valueDes;
          break;
        case r'iterations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.iterations = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SplitHBISeedScanRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SplitHBISeedScanRequestBuilder();
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


