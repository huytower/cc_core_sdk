import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../text/cc_text.dart';

/// Reusable circular badge counter widget for index / notification badge display.
class CcBadgeCounter extends StatelessWidget {
  const CcBadgeCounter({
    super.key,
    required this.count,
    this.backgroundColor,
    this.textColor,
    this.size,
    this.borderWidth,
    this.borderColor,
  });

  /// The number or value to display inside the badge counter.
  final int count;

  /// The background color of the badge. Defaults to [ColorScheme.error].
  final Color? backgroundColor;

  /// The text color of the badge count. Defaults to [ColorScheme.onError].
  final Color? textColor;

  /// Diameter size of the badge. Defaults to 22.
  final double? size;

  /// Optional border width around the badge.
  final double? borderWidth;

  /// Optional border color around the badge.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    final bg = backgroundColor ?? scheme.error;
    final fg = textColor ?? scheme.onError;
    final dimension = size ?? context.respDim(22);

    return Container(
      width: dimension,
      height: dimension,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: borderWidth != null && borderWidth! > 0
            ? Border.all(
                color: borderColor ?? scheme.surface,
                width: borderWidth!,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: CcText(
        count.toString(),
        align: Alignment.center,
        textAlign: TextAlign.center,
        textStyle: context.ccTextTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
      ),
    );
  }
}
