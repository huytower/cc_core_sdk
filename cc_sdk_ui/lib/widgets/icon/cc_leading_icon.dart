import 'package:flutter/cupertino.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../banner/cc_shape_painter.dart';

class CcLeadingIcon extends StatelessWidget {
  const CcLeadingIcon({this.accentColor, this.icon});

  final Color? accentColor;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final size = context.respDim(44);
    final scheme = context.ccColorScheme;
    final color = accentColor ?? scheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.8), color],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          icon ??
              CustomPaint(
                size: Size(size, size),
                painter: CcShapePainter(color: scheme.onPrimary),
              ),
        ],
      ),
    );
  }
}
