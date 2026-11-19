import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:firebase_ai/firebase_ai.dart';

/// Translates the vendor-neutral [CcAiSchema] into Firebase AI's [Schema].
extension CcFirebaseAiSchemaMapper on CcAiSchema {
  Schema toFirebaseSchema() => switch (type) {
    CcAiSchemaType.object => Schema.object(
      properties: {
        for (final MapEntry(:key, :value) in properties!.entries)
          key: value.toFirebaseSchema(),
      },
      optionalProperties: optionalProperties,
      propertyOrdering: propertyOrdering,
      description: description,
      nullable: nullable,
    ),
    CcAiSchemaType.array => Schema.array(
      items: items!.toFirebaseSchema(),
      description: description,
      nullable: nullable,
      minItems: minItems,
      maxItems: maxItems,
    ),
    CcAiSchemaType.boolean => Schema.boolean(
      description: description,
      nullable: nullable,
    ),
    CcAiSchemaType.integer => Schema.integer(
      description: description,
      nullable: nullable,
      format: format,
      minimum: minimum?.toInt(),
      maximum: maximum?.toInt(),
    ),
    CcAiSchemaType.number => Schema.number(
      description: description,
      nullable: nullable,
      format: format,
      minimum: minimum?.toDouble(),
      maximum: maximum?.toDouble(),
    ),
    CcAiSchemaType.string when enumValues != null => Schema.enumString(
      enumValues: enumValues!,
      description: description,
      nullable: nullable,
    ),
    CcAiSchemaType.string => Schema.string(
      description: description,
      nullable: nullable,
      format: format,
    ),
  };
}
