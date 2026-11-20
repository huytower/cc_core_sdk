/// Value type of a [CcAiSchema].
enum CcAiSchemaType { string, number, integer, boolean, array, object }

/// Vendor-neutral description of the JSON an AI model must answer with
/// (structured output), passed to `CcAiClient.generate(responseSchema:)`.
///
/// Mirrors the OpenAPI subset accepted by common AI APIs; an implementation
/// translates it to its vendor's type. [toJson] produces that OpenAPI shape
/// (e.g. `{'type': 'STRING', 'nullable': true}`), handy for tests and logs.
///
/// ```dart
/// CcAiSchema.object(properties: {
///   'title': CcAiSchema.string(description: 'Short title'),
///   'tags': CcAiSchema.array(items: CcAiSchema.string(), maxItems: 3),
/// });
/// ```
class CcAiSchema {
  const CcAiSchema._(
    this.type, {
    this.format,
    this.description,
    this.nullable,
    this.enumValues,
    this.items,
    this.minItems,
    this.maxItems,
    this.minimum,
    this.maximum,
    this.properties,
    this.optionalProperties,
    this.propertyOrdering,
  });

  /// An object with named [properties]; all are required except those in
  /// [optionalProperties]. [propertyOrdering] fixes the order of the output.
  const CcAiSchema.object({
    required Map<String, CcAiSchema> properties,
    List<String>? optionalProperties,
    List<String>? propertyOrdering,
    String? description,
    bool? nullable,
  }) : this._(
         CcAiSchemaType.object,
         properties: properties,
         optionalProperties: optionalProperties,
         propertyOrdering: propertyOrdering,
         description: description,
         nullable: nullable,
       );

  /// A list of [items].
  const CcAiSchema.array({
    required CcAiSchema items,
    String? description,
    bool? nullable,
    int? minItems,
    int? maxItems,
  }) : this._(
         CcAiSchemaType.array,
         items: items,
         description: description,
         nullable: nullable,
         minItems: minItems,
         maxItems: maxItems,
       );

  const CcAiSchema.boolean({String? description, bool? nullable})
    : this._(
        CcAiSchemaType.boolean,
        description: description,
        nullable: nullable,
      );

  const CcAiSchema.integer({
    String? description,
    bool? nullable,
    String? format,
    int? minimum,
    int? maximum,
  }) : this._(
         CcAiSchemaType.integer,
         description: description,
         nullable: nullable,
         format: format,
         minimum: minimum,
         maximum: maximum,
       );

  const CcAiSchema.number({
    String? description,
    bool? nullable,
    String? format,
    num? minimum,
    num? maximum,
  }) : this._(
         CcAiSchemaType.number,
         description: description,
         nullable: nullable,
         format: format,
         minimum: minimum,
         maximum: maximum,
       );

  /// A string restricted to [enumValues].
  const CcAiSchema.enumString({
    required List<String> enumValues,
    String? description,
    bool? nullable,
  }) : this._(
         CcAiSchemaType.string,
         enumValues: enumValues,
         description: description,
         nullable: nullable,
         format: 'enum',
       );

  const CcAiSchema.string({String? description, bool? nullable, String? format})
    : this._(
        CcAiSchemaType.string,
        description: description,
        nullable: nullable,
        format: format,
      );

  final CcAiSchemaType type;
  final String? format;
  final String? description;
  final bool? nullable;
  final List<String>? enumValues;
  final CcAiSchema? items;
  final int? minItems;
  final int? maxItems;
  final num? minimum;
  final num? maximum;
  final Map<String, CcAiSchema>? properties;
  final List<String>? optionalProperties;
  final List<String>? propertyOrdering;

  /// OpenAPI-style JSON, with `required` derived from [optionalProperties].
  Map<String, Object> toJson() => {
    'type': type.name.toUpperCase(),
    'format': ?format,
    'description': ?description,
    'nullable': ?nullable,
    'enum': ?enumValues,
    if (items case final items?) 'items': items.toJson(),
    'minItems': ?minItems,
    'maxItems': ?maxItems,
    if (minimum case final minimum?) 'minimum': minimum.toDouble(),
    if (maximum case final maximum?) 'maximum': maximum.toDouble(),
    if (properties case final properties?) ...{
      'properties': {
        for (final MapEntry(:key, :value) in properties.entries)
          key: value.toJson(),
      },
      'required': [
        for (final key in properties.keys)
          if (!(optionalProperties?.contains(key) ?? false)) key,
      ],
    },
    'propertyOrdering': ?propertyOrdering,
  };
}
