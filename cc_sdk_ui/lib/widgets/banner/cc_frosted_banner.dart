import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_typography_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../space/cc_space.dart';
import '../text/cc_text.dart';

/// Frosted, semi-transparent pill banner with a leading badge,
/// a message, and a trailing chevron.
///
/// This component is project-blind and state-agnostic.
///
/// Usage:
/// ```dart
/// CcFrostedBanner(
///   badgeCount: 2,
///   message: 'You have 2 items in progress',
///   accentColor: Colors.orange,
///   onTap: () {},
/// )
/// ```
class CcFrostedBanner extends StatelessWidget {
  const CcFrostedBanner({
    super.key,
    required this.badgeCount,
    required this.message,
    this.accentColor,
    this.onTap,
  });

  final int badgeCount;
  final String message;
  final Color? accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.respDim(50),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Frosted background and interactive area
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.respDim(32)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: _buildDecoration(context),
                  child: _buildInkWell(context),
                ),
              ),
            ),
          ),
          // Badge moved outside to ignore parent padding
          Positioned(
            left: context.respDim(6),
            top: 0,
            bottom: 0,
            child: Center(
              child: _CcBadge(count: badgeCount, accentColor: accentColor),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    final isDark = context.isDarkMode;
    final scheme = context.ccColorScheme;
    final color = accentColor ?? scheme.primary;

    // Increase alpha in Dark Mode to reduce transparency as requested
    final gradientAlpha = isDark ? 0.8 : 0.2;
    final borderAlpha = 0.1;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(context.respDim(32)),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          color.withValues(alpha: gradientAlpha),
          scheme.onPrimary.withValues(alpha: gradientAlpha),
        ],
      ),
      border: Border.all(
        color: scheme.onSurface.withValues(alpha: borderAlpha),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: scheme.onSurface.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _buildInkWell(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.respDim(28)),
      child: Padding(
        padding: EdgeInsets.only(
          left: context.respDim(58), // Space for badge (44) + padding
          right: context.respDim(10),
          top: context.respDim(6),
          bottom: context.respDim(6),
        ),
        child: Row(
          children: [
            _buildMessage(context),
            _buildChevron(context),
            const CcSpaceXS(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    final isDark = context.isDarkMode;
    return Expanded(
      child: CcText(
        message,
        maxLines: 2,
        textStyle: context.ccTextTheme.bodyMedium?.copyWith(
          fontWeight: CcTypographyParams.bold,
          color: context.ccColorScheme.onSurface.withValues(alpha: 0.8),
          shadows: isDark
              ? [
                  Shadow(
                    color: context.ccColorScheme.onSurface.withValues(
                      alpha: 0.25,
                    ),
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  Widget _buildChevron(BuildContext context) {
    final color = context.isDarkMode
        ? context.ccColorScheme.surface
        : context.ccColorScheme.onSurface;

    return Icon(
      Icons.chevron_right,
      size: context.respIconSize(baseSize: 20),
      color: color.withValues(alpha: 0.3),
    );
  }
}

class _CcBadge extends StatelessWidget {
  const _CcBadge({required this.count, this.accentColor});

  final int count;
  final Color? accentColor;

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
          CustomPaint(
            size: Size(size, size),
            painter: _CcReceiptShapePainter(color: scheme.onPrimary),
          ),
          CcText(
            '$count',
            align: Alignment.center,
            textStyle: context.ccTextTheme.titleMedium?.copyWith(
              fontSize: context.respFontSize(17),
              fontWeight: CcTypographyParams.bold,
              color: scheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CcReceiptShapePainter extends CustomPainter {
  final Color color;

  _CcReceiptShapePainter({required this.color});

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
