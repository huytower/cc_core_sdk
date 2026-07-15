import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';

/// A reusable glassy gradient background component.
///
/// It can be used as a standalone overlay (default) or as a complete
/// background with a base gradient by providing [baseColors].
class CcGlassyGradient extends StatelessWidget {
  final double? borderRadius;
  final Color? endColor;
  final List<double>? stops;

  /// Optional base colors for the background.
  /// If provided, this widget will draw the base gradient AND the glassy overlay.
  final List<Color>? baseColors;

  /// The alignment for the base gradient.
  final AlignmentGeometry? baseBegin;
  final AlignmentGeometry? baseEnd;

  const CcGlassyGradient({
    super.key,
    this.borderRadius,
    this.endColor,
    this.stops,
    this.baseColors,
    this.baseBegin,
    this.baseEnd,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius ?? context.respDim(20)),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0x24FFFFFF), // 14% white
          const Color(0x00FFFFFF), // transparent
          endColor ??
              (baseColors == null
                  ? context.ccColorScheme.primary.withAlpha(60)
                  : Colors.transparent),
        ],
        stops: stops ?? const [0.0, 0.4, 1.0],
      ),
    );

    if (baseColors != null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: decoration.borderRadius,
          gradient: LinearGradient(
            begin: baseBegin ?? Alignment.topLeft,
            end: baseEnd ?? Alignment.bottomRight,
            colors: baseColors!,
          ),
        ),
        child: DecoratedBox(decoration: decoration),
      );
    }

    return DecoratedBox(decoration: decoration);
  }
}
