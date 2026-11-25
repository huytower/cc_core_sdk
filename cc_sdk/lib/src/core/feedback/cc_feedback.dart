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

