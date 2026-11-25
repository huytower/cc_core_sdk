import 'cc_ai_failure.dart';

/// Outcome of [CcAiClient.generate]: [text] on success, [failure] otherwise.
class CcAiResult {
  const CcAiResult.success(String this.text) : failure = null;
  const CcAiResult.failure(CcAiFailure this.failure) : text = null;

  final String? text;
  final CcAiFailure? failure;

  bool get hasSuccess => failure == null;
}

