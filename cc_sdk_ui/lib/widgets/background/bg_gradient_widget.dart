import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_gradient_colors.dart';
import '../../core/extensions/cc_context_extension.dart';

/// A reusable branded gradient background used behind page content.
///
/// Defaults to the semantic [CcGradientColors] token (theme-aware, so it
/// automatically switches between light and dark colors). The top/bottom colors
/// can still be overridden per-call when a non-standard gradient is needed.
///
/// Designed to be placed as the first child of a [Stack] (it fills its parent
/// via [Positioned.fill]).
///
/// Example:
/// ```dart
/// Stack(
///   children: [
///     const BgGradientWidget(),
///     // ... foreground content
///   ],
/// )
/// ```
class BgGradientWidget extends StatelessWidget {
  const BgGradientWidget({
    super.key,
    this.topColor,
    this.bottomColor,
    this.topAlpha = 10,
    this.stops = const [0.0, 1.0],
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  /// Color at the top of the gradient. Defaults to the semantic
  /// [CcGradientColors.top] token (theme-aware).
  final Color? topColor;

  /// Color at the bottom of the gradient. Defaults to the semantic
  /// [CcGradientColors.bottom] token (theme-aware).
  final Color? bottomColor;

  /// Alpha applied to [topColor] (0-255). Defaults to 10 for a faint tint.
  final int topAlpha;

  /// Gradient stop positions for [topColor] and [bottomColor].
  final List<double> stops;

  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  @override
  Widget build(BuildContext context) {
    final token = context.ccGradientColors;
    final top = topColor ?? token.top;
    final bottom = bottomColor ?? token.bottom;

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: [top.withAlpha(topAlpha), bottom],
          ),
        ),
      ),
    );
  }
}
