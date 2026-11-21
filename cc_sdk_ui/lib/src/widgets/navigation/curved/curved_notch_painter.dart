// Adapted from curved_navigation_bar_pro 2.2.3
// (https://pub.dev/packages/curved_navigation_bar_pro), MIT License,
// Copyright (c) 2026 aslamambiloly. Full notice: LICENSE in this folder.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';

/// Paints the bar with a semicircle notch (tangent shoulders) at [notchCX],
/// under the bubble of the selected item.
class CurvedNotchPainter extends CustomPainter {
  const CurvedNotchPainter({
    required this.notchCX,
    required this.notchR,
    required this.fabSink,
    required this.notchShoulderRadius,
    required this.cornerRadius,
    required this.color,
    required this.shadowColor,
    required this.elevation,
  });

  final double notchCX;
  final double notchR;
  final double fabSink;
  final double notchShoulderRadius;
  final double cornerRadius;
  final Color color;
  final Color shadowColor;
  final double elevation;

  @override
  void paint(Canvas canvas, Size size) {
    final barPath = Path()
      ..addRRect(
        RRect.fromLTRBAndCorners(
          0,
          0,
          size.width,
          size.height,
          topLeft: Radius.circular(cornerRadius),
          topRight: Radius.circular(cornerRadius),
        ),
      );

    // Path.combine clips the cutout to the bar, so the notch may run past
    // the edges and corners without artifacts.
    final path = Path.combine(
      PathOperation.difference,
      barPath,
      notchShoulderRadius <= 0.1 ? _plainNotch() : _shoulderNotch(),
    );

    if (elevation > 0) {
      canvas.drawPath(
        path.shift(Offset(0, -elevation * 0.15)),
        Paint()
          ..color = shadowColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, elevation * 0.6),
      );
    }
    canvas.drawPath(path, Paint()..color = color);
  }

  /// Simple semicircle cutout, no shoulder curves.
  Path _plainNotch() {
    final halfChord = math.sqrt(
      math.max(0.0, notchR * notchR - fabSink * fabSink),
    );
    return Path()
      ..moveTo(notchCX - halfChord, 0)
      ..arcToPoint(
        Offset(notchCX + halfChord, 0),
        radius: Radius.circular(notchR),
        clockwise: false,
        largeArc: fabSink > 0,
      )
      ..close();
  }

  /// Cutout whose shoulders meet the top edge of the bar tangentially.
  Path _shoulderNotch() {
    final s = notchShoulderRadius;
    final distSq = math.pow(s + notchR, 2) - math.pow(fabSink - s, 2);
    final dx = math.sqrt(math.max(0.0, distSq.toDouble()));
    final xsLeft = notchCX - dx;
    final xsRight = notchCX + dx;
    final notchCenter = Offset(notchCX, fabSink);
    final ratio = s / (s + notchR);

    Offset tangentPoint(Offset shoulderCenter) => Offset(
      shoulderCenter.dx + (notchCenter.dx - shoulderCenter.dx) * ratio,
      shoulderCenter.dy + (notchCenter.dy - shoulderCenter.dy) * ratio,
    );

    return Path()
      ..moveTo(xsLeft, 0)
      ..arcToPoint(tangentPoint(Offset(xsLeft, s)), radius: Radius.circular(s))
      ..arcToPoint(
        tangentPoint(Offset(xsRight, s)),
        radius: Radius.circular(notchR),
        clockwise: false,
        largeArc: s < fabSink,
      )
      ..arcToPoint(Offset(xsRight, 0), radius: Radius.circular(s))
      ..close();
  }

  @override
  bool shouldRepaint(CurvedNotchPainter old) =>
      old.notchCX != notchCX ||
      old.notchR != notchR ||
      old.fabSink != fabSink ||
      old.notchShoulderRadius != notchShoulderRadius ||
      old.cornerRadius != cornerRadius ||
      old.color != color ||
      old.shadowColor != shadowColor ||
      old.elevation != elevation;
}
