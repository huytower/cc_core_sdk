import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CcAiSchema.toJson', () {
    test('writes the type in upper case and leaves unset fields out', () {
      expect(const CcAiSchema.string().toJson(), {'type': 'STRING'});
      expect(const CcAiSchema.boolean().toJson(), {'type': 'BOOLEAN'});
    });

    test('enumString is a string with the enum format and values', () {
      final json = const CcAiSchema.enumString(
        enumValues: ['low', 'high'],
        description: 'Priority',
      ).toJson();

      expect(json, {
        'type': 'STRING',
        'format': 'enum',
        'description': 'Priority',
        'enum': ['low', 'high'],
      });
    });

    test('numeric bounds are written as doubles', () {
      final json = const CcAiSchema.integer(minimum: 1, maximum: 5).toJson();

      expect(json['minimum'], 1.0);
      expect(json['maximum'], 5.0);
      expect(json['minimum'], isA<double>());
    });

    test('array nests its item schema and keeps the size limits', () {
      final json = const CcAiSchema.array(
        items: CcAiSchema.number(),
        minItems: 1,
        maxItems: 3,
      ).toJson();

      expect(json, {
        'type': 'ARRAY',
        'items': {'type': 'NUMBER'},
        'minItems': 1,
        'maxItems': 3,
      });
    });

    test('object marks every property required unless listed optional', () {
      final json = const CcAiSchema.object(
        properties: {
          'title': CcAiSchema.string(),
          'note': CcAiSchema.string(nullable: true),
        },
        optionalProperties: ['note'],
        propertyOrdering: ['title', 'note'],
      ).toJson();

      expect(json['type'], 'OBJECT');
      expect(json['properties'], {
        'title': {'type': 'STRING'},
        'note': {'type': 'STRING', 'nullable': true},
      });
      expect(json['required'], ['title']);
      expect(json['propertyOrdering'], ['title', 'note']);
    });
  });

  group('CcAiResult', () {
    test('success carries the text and no failure', () {
      const result = CcAiResult.success('{"ok":true}');

      expect(result.isSuccess, isTrue);
      expect(result.text, '{"ok":true}');
      expect(result.failure, isNull);
    });

    test('failure carries the kind and no text', () {
      const result = CcAiResult.failure(
        CcAiFailure(CcAiFailureKind.deviceAttestation, cause: 'denied'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.text, isNull);
      expect(result.failure!.kind, CcAiFailureKind.deviceAttestation);
      expect(
        result.failure.toString(),
        'CcAiFailure(deviceAttestation: denied)',
      );
    });
  });
}
