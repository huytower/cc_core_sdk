import 'dart:typed_data';

import 'cc_ai_schema.dart';

/// Generative AI (text and image prompts), independent of any vendor.
///
/// The SDK core only defines this contract. An implementation comes from a
/// capability package (e.g. `CcFirebaseAiClient` in `cc_sdk_firebase`),
/// registered in DI as `CcAiClient`. Implementations never throw: a failed
/// call returns a [CcAiResult] with a [CcAiFailure], so an AI feature can
/// degrade gracefully.
///
/// ```dart
/// final result = await ai.generate(prompt: 'Summarise: $text');
/// if (result.text case final text?) show(text);
/// ```
abstract interface class CcAiClient {
  /// Sends [prompt], with optional [images] (multimodal). A non-null
  /// [responseSchema] asks for strict JSON in that shape.
  Future<CcAiResult> generate({
    required String prompt,
    List<CcAiImage> images = const [],
    CcAiSchema? responseSchema,
  });
}

/// An image sent with a prompt.
class CcAiImage {
  const CcAiImage({required this.bytes, required this.mimeType});

  final Uint8List bytes;

  /// e.g. `image/jpeg`, `image/png`, `image/webp`.
  final String mimeType;
}

/// Outcome of [CcAiClient.generate]: [text] on success, [failure] otherwise.
class CcAiResult {
  const CcAiResult.success(String this.text) : failure = null;
  const CcAiResult.failure(CcAiFailure this.failure) : text = null;

  final String? text;
  final CcAiFailure? failure;

  bool get hasSuccess => failure == null;
}

/// Why a generation failed, as far as callers need to react differently.
enum CcAiFailureKind {
  /// The device failed app attestation (emulator, rooted, not genuine);
  /// retrying will not help and the UI can say so.
  deviceAttestation,

  /// Any other failure (network, quota, server, invalid response).
  unknown,
}

class CcAiFailure {
  const CcAiFailure(this.kind, {this.cause});

  final CcAiFailureKind kind;

  /// The underlying error, for logs and crash reports.
  final Object? cause;

  @override
  String toString() => 'CcAiFailure(${kind.name}: $cause)';
}
