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

/// One piece of user feedback.
class CcFeedback {
  const CcFeedback({
    required this.text,
    this.praise = const [],
    this.criticism = const [],
    this.rating,
  });

  /// Free text written by the user (may be empty).
  final String text;

  /// Already-translated tags the user picked as positives / negatives.
  final List<String> praise;
  final List<String> criticism;

  /// Average star rating out of 5, if the user rated.
  final double? rating;
}

/// Captions used when a channel renders [CcFeedback] for people to read.
/// The app passes translated values; the SDK holds no translations.
class CcFeedbackLabels {
  const CcFeedbackLabels({
    required this.title,
    required this.rating,
    required this.praise,
    required this.criticism,
    required this.text,
    required this.none,
    required this.noText,
    required this.notRated,
  });

  /// Neutral English fallback.
  static const english = CcFeedbackLabels(
    title: 'User feedback',
    rating: 'Rating',
    praise: 'Praise',
    criticism: 'Criticism',
    text: 'Feedback',
    none: '(none)',
    noText: '(no text)',
    notRated: '(not rated)',
  );

  final String title;
  final String rating;
  final String praise;
  final String criticism;
  final String text;
  final String none;
  final String noText;
  final String notRated;
}

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
