import 'dart:math';

import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A small pie that fills clockwise from the top to show [progress]
/// (0.0–1.0, clamped), inside a thin outline circle.
///
/// ```dart
/// CcProgressPie(progress: spent / limit, color: Colors.orange, size: 24)
/// ```
class CcProgressPie extends StatelessWidget {
  const CcProgressPie({
    super.key,
    required this.progress,
    required this.color,
    required this.size,
  });

  final double progress;
  final Color color;

  /// Width and height of the pie.
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _ProgressPiePainter(
        progress: progress.clamp(0.0, 1.0),
        color: color,
        outlineColor: context.ccColorScheme.onSurface.withValues(alpha: 0.1),
      ),
    );
  }
}

class _ProgressPiePainter extends CustomPainter {
  _ProgressPiePainter({
    required this.progress,
    required this.color,
    required this.outlineColor,
  });

  final double progress;
  final Color color;
  final Color outlineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = outlineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        true,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressPiePainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.outlineColor != outlineColor;
}
