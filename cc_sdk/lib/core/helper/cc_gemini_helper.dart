import 'dart:typed_data';

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

  static const String _modelName = 'gemini-2.5-flash';

  static GenerativeModel? _model;

  static GenerativeModel _getModel() {
    return _model ??= FirebaseAI.googleAI().generativeModel(
      model: _modelName,
    );
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
  /// [prompt] (multimodal).
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
