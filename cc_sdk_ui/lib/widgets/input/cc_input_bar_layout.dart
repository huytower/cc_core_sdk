import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

/// A standardized layout for input bars, following the pattern:
/// [Leading] [Gap] [Middle (Expanded)] [Gap] [Trailing]
///
/// It handles responsive padding and standard spacing between elements.
class CcInputBarLayout extends StatelessWidget {
  const CcInputBarLayout({
    super.key,
    this.leading,
    required this.middle,
    this.trailing,
    this.horizontalPadding,
    this.gap,
  });

  /// The widget to display at the start of the bar (e.g., prefix icons).
  final Widget? leading;

  /// The primary content, usually a [TextField], which takes up all remaining space.
  final Widget middle;

  /// The widget to display at the end of the bar (e.g., voice/action icons).
  final Widget? trailing;

  /// Custom horizontal padding. Defaults to `context.respPadding(16)`.
  final double? horizontalPadding;

  /// Custom gap between widgets. Defaults to `CcSpaceSM()`.
  final Widget? gap;

  @override
  Widget build(BuildContext context) {
    final defaultGap = gap ?? const CcSpaceSM();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? context.respPadding(16),
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, defaultGap],
          Expanded(child: middle),
          if (trailing != null) ...[defaultGap, trailing!],
        ],
      ),
    );
  }
}
