import 'package:cc_sdk_ui/core/config/tokens/cc_border_radius.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';

/// A reusable glassy gradient background component.
///
/// It can be used as a standalone overlay (default) or as a complete
/// background with a base gradient by providing [baseColors].
class CcGlassyGradientBackground extends StatelessWidget {
  final Color? centerColor, endColor;
  final List<double>? stops;

  /// The alignment for the base gradient.
  final AlignmentGeometry? linearGradientBegin;
  final AlignmentGeometry? linearGradientEnd;

  const CcGlassyGradientBackground({
    super.key,
    this.centerColor,
    this.endColor,
    this.stops,
    this.linearGradientBegin,
    this.linearGradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: context.brLg,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          context.ccColorScheme.onPrimary.withAlpha(15), // 15% white highlight
          centerColor ?? context.ccColorScheme.primary.withAlpha(30),
          endColor ?? context.ccColorScheme.primary.withAlpha(50),
        ],
        stops: stops ?? const [0.0, 0.4, 1.0],
      ),
    );

    return DecoratedBox(decoration: decoration);
  }
}

class CcGlassyGradientIcon extends StatelessWidget {
  final Color? centerColor, endColor;
  final List<double>? stops;

  /// The alignment for the base gradient.
  final AlignmentGeometry? linearGradientBegin;
  final AlignmentGeometry? linearGradientEnd;

  const CcGlassyGradientIcon({
    super.key,
    this.centerColor,
    this.endColor,
    this.stops,
    this.linearGradientBegin,
    this.linearGradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: context.brLg,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          context.ccColorScheme.onPrimary.withAlpha(15), // 15% white highlight
          centerColor ?? context.ccColorScheme.primary.withAlpha(30),
          endColor ?? context.ccColorScheme.primary.withAlpha(50),
        ],
        stops: stops ?? const [0.0, 0.4, 1.0],
      ),
    );

    return DecoratedBox(decoration: decoration);
  }
}
