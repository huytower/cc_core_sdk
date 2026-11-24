import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A pill of tappable stars (1–[maxRating]) followed by a text built from the
/// selected rating, e.g. "4.0 / 5".
///
/// Starts at [initialRating], or [averageRating] rounded.
///
/// ```dart
/// CcRatingPill(
///   averageRating: 4.3,
///   ratingLabel: (rating) => '$rating.0 / 5',
///   onRatingSelected: submitRating,
/// )
/// ```
class CcRatingPill extends StatefulWidget {
  const CcRatingPill({
    super.key,
    required this.averageRating,
    required this.ratingLabel,
    this.initialRating,
    this.onRatingSelected,
    this.maxRating = 5,
  });

  final double averageRating;

  /// Text shown after the stars for the selected rating (already translated).
  final String Function(int rating) ratingLabel;
  final int? initialRating;
  final ValueChanged<int>? onRatingSelected;
  final int maxRating;

  @override
  State<CcRatingPill> createState() => _CcRatingPillState();
}

class _CcRatingPillState extends State<CcRatingPill> {
  late int _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedRating =
        widget.initialRating ??
        widget.averageRating.round().clamp(1, widget.maxRating);
  }

  void _select(int rating) {
    setState(() => _selectedRating = rating);
    widget.onRatingSelected?.call(rating);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: context.brPill,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.respPadding(16),
          vertical: context.respPadding(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= widget.maxRating; i++) ...[
              if (i > 1) const CcSpaceXS(),
              CcIconButton.bouncing(
                onTap: () => _select(i),
                icon: Icon(
                  i <= _selectedRating
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: scheme.primary,
                  size: context.respDim(24),
                ),
                width: context.respDim(28),
                height: context.respDim(28),
              ),
            ],
            const CcSpaceSM(),
            CcText(
              widget.ratingLabel(_selectedRating),
              textStyle: context.ccTextTheme.bodyMedium?.copyWith(
                fontWeight: CcTypographyParams.bold,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
