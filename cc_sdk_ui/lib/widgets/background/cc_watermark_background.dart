import 'package:flutter/material.dart';

import '../../core/extensions/common/cc_responsive_extension.dart';

/// Renders a slightly tinted background with a large, faded watermark icon
/// spilling out of the bottom-right corner.
/// Used commonly for visually distinct group sections (like category groups).
class CcWatermarkBackground extends StatelessWidget {
  final Widget child;
  final IconData icon;
  final Color activeColor;

  const CcWatermarkBackground({
    super.key,
    required this.child,
    required this.icon,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: activeColor.withValues(alpha: 0.08)),
        ),
        Positioned(
          right: -context.respDim(20),
          bottom: -context.respDim(20),
          child: Icon(
            icon,
            size: context.respDim(120),
            color: activeColor.withValues(alpha: 0.1),
          ),
        ),
        child,
      ],
    );
  }
}
