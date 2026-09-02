import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../text/cc_text.dart';

/// A subtle text-based empty state intended for sections or cards.
///
/// Matches the design pattern used across the dashboard (e.g. Wallets,
/// Investments, Liabilities).
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
        textAlign: TextAlign.center,
        textStyle: context.ccTextTheme.bodySmall?.copyWith(
          color: context.ccColorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
