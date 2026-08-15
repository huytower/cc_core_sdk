import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';

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

  /// Sends [prompt] to Gemini and returns the raw text response, or null on
  /// any failure (API not enabled, network error, safety-filtered response,
  /// etc.).
  static Future<String?> generateText({required String prompt}) async {
    try {
      final response = await _getModel().generateContent([
        Content.text(prompt),
      ]);
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
  }) async {
    try {
      final response = await _getModel().generateContent([
        Content.multi([TextPart(prompt), InlineDataPart(mimeType, imageBytes)]),
      ]);
      return response.text;
    } catch (_) {
      return null;
    }
  }
}
