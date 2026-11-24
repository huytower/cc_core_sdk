import 'package:flutter/cupertino.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../banner/cc_shape_painter.dart';

class CcLeadingIcon extends StatelessWidget {
  const CcLeadingIcon({this.backgroundColor, this.icon});

  final Color? backgroundColor;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final size = context.respDim(40);
    final scheme = context.ccColorScheme;
    final background = backgroundColor ?? scheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            background.withValues(alpha: 0.2),
            background.withValues(alpha: 0.5),
          ],
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
