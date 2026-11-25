import 'package:flutter/material.dart';

class CcGridPatternPainter extends CustomPainter {
  final Color color;

  CcGridPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final double squareSize = size.height / 6;
    const int rows = 6;
    const int cols = 5;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final bool shouldPaint = (r + c).isEven;
        if (!shouldPaint) continue;

        final double opacity = ((r * c) % 3 == 0) ? 0.04 : 0.015;

        paint.color = color.withValues(alpha: opacity);
        canvas.drawRect(
          Rect.fromLTWH(
            size.width - (c + 1) * squareSize,
            r * squareSize,
            squareSize - 2,
            squareSize - 2,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

