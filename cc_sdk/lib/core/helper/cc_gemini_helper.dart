import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';

// Re-exported so callers can build a [Schema] for [CcGeminiHelper]'s
// `responseSchema` param without adding a direct `firebase_ai` dependency of
// their own — same "no direct dependency" convention as the rest of this
// class.
export 'package:firebase_ai/firebase_ai.dart' show Schema, SchemaType;

/// Thin wrapper around Firebase AI Logic's Gemini access, encapsulated so
/// callers never need a direct `firebase_ai` dependency of their own (same
/// convention as [CcLocationHelper] wrapping `geolocator`). Fails silently
/// on any error — including "Gemini API not enabled for this Firebase
/// project yet" — since this backs a best-effort cloud fallback that must
/// degrade gracefully to "couldn't understand, please fill manually" rather
/// than crash.
class CcGeminiHelper {
  CcGeminiHelper._();

  static const String _modelName = 'gemini-2.5-flash';

  static GenerativeModel? _model;

  static GenerativeModel _getModel() {
    return _model ??= FirebaseAI.googleAI().generativeModel(
      model: _modelName,
    );
  }

  /// Forces strict JSON mode constrained to [responseSchema] when given —
  /// null leaves the model on its default free-text output, so callers that
  /// just want prose (e.g. financial-advice generation) are unaffected.
  static GenerationConfig? _jsonConfig(Schema? responseSchema) {
    if (responseSchema == null) return null;
    return GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: responseSchema,
    );
  }

  /// Sends [prompt] to Gemini and returns the raw text response, or null on
  /// any failure (API not enabled, network error, safety-filtered response,
  /// etc.). Pass [responseSchema] to constrain the reply to strict JSON
  /// matching that schema — Gemini then returns explicit `null`s for
  /// fields it can't determine instead of omitting them or wrapping the
  /// reply in prose/markdown fences.
  static Future<String?> generateText({
    required String prompt,
    Schema? responseSchema,
  }) async {
    try {
      final response = await _getModel().generateContent(
        [Content.text(prompt)],
        generationConfig: _jsonConfig(responseSchema),
      );
      return response.text;
    } catch (_) {
      return null;
    }
  }

  /// Same contract as [generateText], but sends [imageBytes] alongside
  /// [prompt] (multimodal) — backs the Phase 3.7 receipt-photo cloud
  /// fallback, where the image itself is more reliable than pre-extracted
  /// OCR text for small/faded receipt print.
  static Future<String?> generateFromImage({
    required Uint8List imageBytes,
    required String mimeType,
    required String prompt,
    Schema? responseSchema,
  }) async {
    try {
      final response = await _getModel().generateContent(
        [
          Content.multi([
            TextPart(prompt),
            InlineDataPart(mimeType, imageBytes),
          ]),
        ],
        generationConfig: _jsonConfig(responseSchema),
      );
      return response.text;
    } catch (_) {
      return null;
    }
  }
}
