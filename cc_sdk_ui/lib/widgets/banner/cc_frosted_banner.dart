import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_typography_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../icon/cc_leading_icon.dart';
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
    this.icon,
    this.showChevron = true,
  });

  final int badgeCount;
  final String message;
  final Color? accentColor;
  final VoidCallback? onTap;
  final Widget? icon;
  final bool showChevron;

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
            left: context.respDim(4),
            top: context.respDim(4),
            bottom: context.respDim(4),
            child: Center(
              child: CcLeadingIcon(bgColor: accentColor, icon: icon),
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
            if (showChevron) _buildChevron(context),
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
