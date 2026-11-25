import 'cc_ai_image.dart';
import 'cc_ai_result.dart';
import 'cc_ai_schema.dart';

export 'cc_ai_failure.dart';
export 'cc_ai_failure_kind.dart';
export 'cc_ai_image.dart';
export 'cc_ai_result.dart';

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
