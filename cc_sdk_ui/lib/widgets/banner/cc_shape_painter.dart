import 'package:flutter/material.dart';

/// Draws a small "receipt" glyph (two lines + a zigzag bottom edge) centered
/// within the given [Size].
class CcShapePainter extends CustomPainter {
  final Color color;

  const CcShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.24),
      Offset(size.width * 0.62, size.height * 0.24),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.32),
      Offset(size.width * 0.5, size.height * 0.32),
      linePaint,
    );

    final Paint zigzagPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final double baseY = size.height * 0.78;
    final Path zigzag = Path()..moveTo(size.width * 0.22, baseY);
    const int teeth = 5;
    final double step = (size.width * 0.56) / teeth;
    for (int i = 0; i < teeth; i++) {
      final double x1 = size.width * 0.22 + step * i + step / 2;
      final double x2 = size.width * 0.22 + step * (i + 1);
      zigzag.lineTo(x1, baseY + 5);
      zigzag.lineTo(x2, baseY);
    }
    canvas.drawPath(zigzag, zigzagPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
