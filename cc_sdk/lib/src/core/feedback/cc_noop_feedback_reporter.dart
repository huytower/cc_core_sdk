import 'cc_feedback_reporter.dart';

/// [CcFeedbackReporter] that delivers nothing: for tests and apps without a
/// feedback channel.
class CcNoopFeedbackReporter implements CcFeedbackReporter {
  const CcNoopFeedbackReporter();

  @override
  Future<bool> send(
    CcFeedback feedback, {
    CcFeedbackLabels labels = CcFeedbackLabels.english,
  }) async => false;
}
