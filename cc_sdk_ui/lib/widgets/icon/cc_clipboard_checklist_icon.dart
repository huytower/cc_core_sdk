import 'package:flutter/material.dart';

/// Recreates the "clipboard checklist" icon — blue rounded body, dark navy
/// clip at the top with a white halo cutout, and 3 rows of white
/// checkmark + line — drawn entirely with [CustomPainter] (no image asset).
///
/// Usage:
/// ```dart
/// const CcClipboardChecklistIcon(size: 96)
/// ```
class CcClipboardChecklistIcon extends StatelessWidget {
  const CcClipboardChecklistIcon({
    super.key,
    this.size = 96,
    this.bodyColor = const Color(0xFF2E7DBE),
    this.clipColor = const Color(0xFF3B4550),
    this.markColor = Colors.white,
  });

  final double size;
  final Color bodyColor;
  final Color clipColor;
  final Color markColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _ClipboardChecklistPainter(
        bodyColor: bodyColor,
        clipColor: clipColor,
        markColor: markColor,
      ),
    );
  }
}

class _ClipboardChecklistPainter extends CustomPainter {
  _ClipboardChecklistPainter({
    required this.bodyColor,
    required this.clipColor,
    required this.markColor,
  });

  final Color bodyColor;
  final Color clipColor;
  final Color markColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // ---- 1. Clipboard body (blue rounded rect) ----
    final RRect body = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.255, h * 0.285, w * 0.49, h * 0.60),
      Radius.circular(w * 0.035),
    );
    canvas.drawRRect(body, Paint()..color = bodyColor);

    // ---- 2. White halo notch behind the clip ----
    final RRect notch = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.335, h * 0.225, w * 0.33, h * 0.14),
      Radius.circular(w * 0.05),
    );
    canvas.drawRRect(notch, Paint()..color = Colors.white);

    // ---- 3. Clip bar (dark, horizontal) ----
    final RRect clipBar = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.355, h * 0.255, w * 0.29, h * 0.075),
      Radius.circular(w * 0.03),
    );
    canvas.drawRRect(clipBar, Paint()..color = clipColor);

    // ---- 4. Clip knob (dark, rounded-top vertical piece) ----
    final RRect clipKnob = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.43, h * 0.125, w * 0.14, h * 0.16),
      topLeft: Radius.circular(w * 0.07),
      topRight: Radius.circular(w * 0.07),
    );
    canvas.drawRRect(clipKnob, Paint()..color = clipColor);

    // ---- 5. Three rows of checkmark + line ----
    final List<double> rowCenters = [h * 0.50, h * 0.635, h * 0.77];
    for (final double cy in rowCenters) {
      _drawCheckmark(canvas, center: Offset(w * 0.365, cy), scale: w);
      _drawLine(canvas, y: cy, scale: w);
    }
  }

  void _drawCheckmark(
    Canvas canvas, {
    required Offset center,
    required double scale,
  }) {
    final Paint paint = Paint()
      ..color = markColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.028
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double r = scale * 0.045;
    final Path path = Path()
      ..moveTo(center.dx - r, center.dy)
      ..lineTo(center.dx - r * 0.25, center.dy + r * 0.75)
      ..lineTo(center.dx + r * 1.1, center.dy - r * 0.85);

    canvas.drawPath(path, paint);
  }

  void _drawLine(Canvas canvas, {required double y, required double scale}) {
    final Paint paint = Paint()
      ..color = markColor
      ..strokeWidth = scale * 0.032
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(scale * 0.455, y), Offset(scale * 0.685, y), paint);
  }

  @override
  bool shouldRepaint(covariant _ClipboardChecklistPainter oldDelegate) {
    return oldDelegate.bodyColor != bodyColor ||
        oldDelegate.clipColor != clipColor ||
        oldDelegate.markColor != markColor;
  }
}
