import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:injectable/injectable.dart';

import 'cc_firebase_ai_config.dart';
import 'cc_firebase_ai_schema_mapper.dart';

/// [CcAiClient] backed by Gemini through Firebase AI Logic.
///
/// The model comes from the app's [CcFirebaseAiConfig] (see [modelNameFrom]).
/// Transient 5xx errors are retried; a final failure is reported to
/// [CcCrashReporter] as non-fatal and returned as a [CcAiFailure], never
/// thrown.
@LazySingleton(as: CcAiClient)
class CcFirebaseAiClient implements CcAiClient {
  CcFirebaseAiClient(this._crashReporter, this._config);

  final CcCrashReporter _crashReporter;
  final CcFirebaseAiConfig _config;
  GenerativeModel? _model;

  static const String defaultModelName = 'gemini-3.8-flash';

  /// Firebase AI Logic reports server errors as a [FirebaseAIException] whose
  /// message starts with `Server Error [<code>]` (no status code field).
  static const int _maxAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  static final RegExp _serverErrorCodePattern = RegExp(
    r'^Server Error \[(\d{3})\]',
  );

  /// The model id sent to Firebase for a configured [name]: blank uses
  /// [defaultModelName], and a missing `gemini-` prefix is added.
  static String modelNameFrom(String name) {
    final trimmed = name.trim();
    final resolved = trimmed.isEmpty ? defaultModelName : trimmed;
    return resolved.startsWith('gemini-') ? resolved : 'gemini-$resolved';
  }

  GenerativeModel get _generativeModel => _model ??= FirebaseAI.googleAI()
      .generativeModel(model: modelNameFrom(_config.modelName));

  @override
  Future<CcAiResult> generate({
    required String prompt,
    List<CcAiImage> images = const [],
    CcAiSchema? responseSchema,
  }) async {
    final contents = [
      images.isEmpty
          ? Content.text(prompt)
          : Content.multi([
              TextPart(prompt),
              for (final image in images)
                InlineDataPart(image.mimeType, image.bytes),
            ]),
    ];
    final config = responseSchema == null
        ? null
        : GenerationConfig(
            responseMimeType: 'application/json',
            responseSchema: responseSchema.toFirebaseSchema(),
          );

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        final response = await _generativeModel.generateContent(
          contents,
          generationConfig: config,
        );
        final text = response.text;
        if (text == null || text.trim().isEmpty) {
          return _fail(StateError('Empty AI response'));
        }
        return CcAiResult.success(text);
      } catch (e, stack) {
        if (attempt < _maxAttempts && _isTransientServerError(e)) {
          await Future<void>.delayed(_retryDelay);
          continue;
        }
        await _crashReporter.recordError(
          e,
          stack,
          reason:
              '[CcFirebaseAiClient] generate failed '
              '(model: ${modelNameFrom(_config.modelName)}, images: ${images.length}): $e',
        );
        return _fail(e);
      }
    }
    return _fail(StateError('AI retries exhausted'));
  }

  CcAiResult _fail(Object cause) {
    return CcAiResult.failure(CcAiFailure(classify(cause), cause: cause));
  }

  /// App Check (attestation) failures surface only in the error text.
  static CcAiFailureKind classify(Object error) {
    final text = error.toString().toLowerCase();
    final attestation =
        text.contains('firebase_app_check') ||
        text.contains('app attestation failed') ||
        text.contains('app check');
    return attestation
        ? CcAiFailureKind.deviceAttestation
        : CcAiFailureKind.unknown;
  }

  static bool _isTransientServerError(Object error) {
    if (error is! FirebaseAIException) return false;
    final match = _serverErrorCodePattern.firstMatch(error.message);
    return match != null && int.parse(match.group(1)!) >= 500;
  }
}
