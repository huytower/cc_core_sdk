import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../text/cc_text.dart';

/// A subtle text-based empty state intended for sections or cards.
///
/// Use it where a section or card has nothing to show yet, in place of a full-page
/// empty state.
class CcSectionEmptyState extends StatelessWidget {
  const CcSectionEmptyState({
    super.key,
    required this.message,
    this.verticalPadding = 24,
    this.horizontalPadding = 24,
  });

  final String message;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.respDim(verticalPadding),
        horizontal: context.respDim(horizontalPadding),
      ),
      alignment: Alignment.center,
      child: CcText(
        message,
        maxLines: 3,
        textAlign: TextAlign.center,
        textStyle: context.ccTextTheme.bodySmall?.copyWith(
          color: context.ccColorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
