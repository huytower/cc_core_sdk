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

