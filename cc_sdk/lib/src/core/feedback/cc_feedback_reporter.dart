import 'cc_feedback.dart';
import 'cc_feedback_labels.dart';

export 'cc_feedback.dart';
export 'cc_feedback_labels.dart';
export 'cc_noop_feedback_reporter.dart';

/// Sends in-app user feedback to the team, independent of the channel.
///
/// The SDK core only defines this contract. An implementation comes from a
/// capability package (e.g. `CcSlackFeedbackReporter` in `cc_sdk_slack`) or
/// from the app (e.g. a call to its own backend), registered in DI as
/// `CcFeedbackReporter`. Implementations never throw: a failure to deliver
/// must not block the feedback flow shown to the user.
///
/// ```dart
/// await reporter.send(
///   const CcFeedback(text: 'Love it', praise: ['Fast'], rating: 4.5),
///   labels: myTranslatedLabels,
/// );
/// ```
abstract interface class CcFeedbackReporter {
  /// Delivers [feedback]; `true` if the channel accepted it. [labels] are
  /// the already-translated captions a human-readable channel shows.
  Future<bool> send(
    CcFeedback feedback, {
    CcFeedbackLabels labels = CcFeedbackLabels.english,
  });
}
