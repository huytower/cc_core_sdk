import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_firebase/export_cc_sdk_firebase.dart';
import 'package:cc_sdk_firebase/src/ai/cc_firebase_ai_schema_mapper.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CcAiSchema -> Firebase Schema', () {
    // Covers every builder and option the app uses, nested.
    const schema = CcAiSchema.object(
      properties: {
        'kind': CcAiSchema.enumString(
          enumValues: ['a', 'b'],
          description: 'Kind',
        ),
        'rows': CcAiSchema.array(
          minItems: 1,
          maxItems: 5,
          description: 'Rows',
          items: CcAiSchema.object(
            properties: {
              'amount': CcAiSchema.number(nullable: true, minimum: 0.01),
              'count': CcAiSchema.integer(minimum: 1, maximum: 9),
              'note': CcAiSchema.string(description: 'Note', nullable: true),
              'done': CcAiSchema.boolean(),
            },
            optionalProperties: ['note'],
            propertyOrdering: ['amount', 'count', 'note', 'done'],
          ),
        ),
      },
      propertyOrdering: ['kind', 'rows'],
    );

    test('produces the same JSON as the Firebase schema it maps to', () {
      expect(schema.toJson(), schema.toFirebaseSchema().toJson());
    });

    test('keeps enum strings as Firebase enum strings', () {
      final mapped = const CcAiSchema.enumString(
        enumValues: ['x'],
      ).toFirebaseSchema();
      expect(mapped.type, SchemaType.string);
      expect(mapped.format, 'enum');
      expect(mapped.enumValues, ['x']);
    });
  });

  group('CcFirebaseAiClient.classify', () {
    test('detects App Check / attestation failures', () {
      for (final message in [
        'FirebaseException [firebase_app_check/unknown] boom',
        'App attestation failed',
        'Missing App Check token',
      ]) {
        expect(
          CcFirebaseAiClient.classify(Exception(message)),
          CcAiFailureKind.deviceAttestation,
          reason: message,
        );
      }
    });

    test('treats anything else as unknown', () {
      expect(
        CcFirebaseAiClient.classify(Exception('Server Error [503]')),
        CcAiFailureKind.unknown,
      );
    });
  });
}
