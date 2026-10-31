import 'dart:typed_data';

import 'package:cc_sdk/core/extensions/common/cc_logger_extension.dart';
import 'package:firebase_ai/firebase_ai.dart';

// Re-exported so callers can build a [Schema] for [CcGeminiHelper]'s
// `responseSchema` param without adding a direct `firebase_ai` dependency of
// their own — same "no direct dependency" convention as the rest of this
// class.
export 'package:firebase_ai/firebase_ai.dart' show Schema, SchemaType;

/// Thin wrapper around Firebase AI Logic's Gemini access, so callers never
/// need a direct `firebase_ai` dependency. Fails silently on any error —
/// this backs a best-effort cloud fallback that must degrade gracefully
/// rather than crash.
class CcGeminiHelper {
  CcGeminiHelper._();

  static const String _modelName = 'gemini-3.8-flash';

  static GenerativeModel? _model;

  /// Retries for transient 5xx responses (e.g. "high demand" 500s) — Firebase
  /// AI Logic surfaces those as a [FirebaseAIException] whose message starts
  /// with `Server Error [<code>]`, since the SDK doesn't expose a status code
  /// field directly (see `HttpApiClient.makeRequest`).
  static const int _maxAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  static final RegExp _serverErrorCodePattern = RegExp(
    r'^Server Error \[(\d{3})\]',
  );

  static GenerativeModel _getModel() {
    return _model ??= FirebaseAI.googleAI().generativeModel(model: _modelName);
  }

  static bool _isTransientServerError(Object error) {
    if (error is! FirebaseAIException) return false;
    final match = _serverErrorCodePattern.firstMatch(error.message);
    if (match == null) return false;
    return int.parse(match.group(1)!) >= 500;
  }

  /// Null [responseSchema] leaves the model on default free-text output.
  static GenerationConfig? _jsonConfig(Schema? responseSchema) {
    if (responseSchema == null) return null;
    return GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: responseSchema,
    );
  }

  /// Returns the raw text response, or null on any failure. [responseSchema]
  /// constrains the reply to strict JSON, so unresolved fields come back as
  /// explicit `null` instead of being omitted or wrapped in prose/markdown.
  static Future<String?> generateText({
    required String prompt,
    Schema? responseSchema,
  }) => _generateWithRetry(
    label: 'generateText',
    contents: [Content.text(prompt)],
    responseSchema: responseSchema,
  );

  static Future<String?> _generateWithRetry({
    required String label,
    required List<Content> contents,
    Schema? responseSchema,
  }) async {
    '[CcGeminiHelper] 🤖 Calling Firebase AI Gemini model ($_modelName) for $label (hasSchema: ${responseSchema != null})...'
        .Log('CcGeminiHelper');
    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        final response = await _getModel().generateContent(
          contents,
          generationConfig: _jsonConfig(responseSchema),
        );
        final text = response.text;
        '[CcGeminiHelper] ✅ Firebase AI response received for $label | length=${text?.length ?? 0}'
            .Log('CcGeminiHelper');
        return text;
      } catch (e) {
        final canRetry = attempt < _maxAttempts && _isTransientServerError(e);
        '[CcGeminiHelper] ❌ $label attempt $attempt/$_maxAttempts failed (${canRetry ? 'retrying' : 'giving up'}): $e'
            .Log('CcGeminiHelper');
        if (!canRetry) return null;
        await Future.delayed(_retryDelay);
      }
    }
    return null;
  }

  /// Same contract as [generateText], but sends [imageBytes] alongside
  /// [prompt] (multimodal).
  static Future<String?> generateFromImage({
    required Uint8List imageBytes,
    required String mimeType,
    required String prompt,
    Schema? responseSchema,
  }) async {
    try {
      final response = await _getModel().generateContent([
        Content.multi([TextPart(prompt), InlineDataPart(mimeType, imageBytes)]),
      ], generationConfig: _jsonConfig(responseSchema));
      return response.text;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> generateFromImages({
    required List<({Uint8List bytes, String mimeType})> images,
    required String prompt,
    Schema? responseSchema,
  }) => _generateWithRetry(
    label: 'generateFromImages',
    contents: [
      Content.multi([
        TextPart(prompt),
        for (final image in images) InlineDataPart(image.mimeType, image.bytes),
      ]),
    ],
    responseSchema: responseSchema,
  );
}
