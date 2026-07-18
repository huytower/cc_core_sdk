import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_border_radius.dart';
import '../../core/config/tokens/cc_typography_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../icon/cc_leading_icon.dart';
import '../space/cc_space.dart';
import '../text/cc_text.dart';

/// Frosted, semi-transparent pill banner with a leading badge,
/// a message, and a trailing chevron.
///
/// Supports an optional [description] displayed below the message,
/// following the same visual pattern as [CcListBanner].
///
/// This component is project-blind and state-agnostic.
///
/// Usage:
/// ```dart
/// CcFrostedBanner(
///   badgeCount: 2,
///   title: 'You have 2 items in progress',
///   description: 'Tap to view details',
///   accentColor: Colors.orange,
///   onTap: () {},
/// )
/// ```
class CcListBannerSmall extends StatelessWidget {
  const CcListBannerSmall({
    super.key,
    required this.title,
    this.description,
    this.accentColor,
    this.onTap,
    this.icon,
    this.showChevron = true,
  });

  final String title;
  final String? description;
  final Color? accentColor;
  final VoidCallback? onTap;
  final Widget? icon;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: description != null && description!.isNotEmpty
          ? context.respDim(60)
          : context.respDim(45),
      child: ClipRRect(
        borderRadius: CcBorderRadius.xxl(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: _buildDecoration(context),
            child: InkWell(
              onTap: onTap,
              borderRadius: CcBorderRadius.xxl(context),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.respDim(4),
                  vertical: context.respDim(4),
                ),
                child: Row(
                  children: [
                    CcLeadingIcon(bgColor: accentColor, icon: icon),
                    const CcSpaceSM(),
                    _buildMessage(context),
                    if (showChevron) _buildChevron(context),
                    const CcSpaceXS(),
                  ],
                ),
              ),
            ),
          ),
        ),
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
      borderRadius: CcBorderRadius.xxl(context),
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

  Widget _buildMessage(BuildContext context) {
    final isDark = context.isDarkMode;
    final titleStyle = context.ccTextTheme.bodySmall?.copyWith(
      fontWeight: CcTypographyParams.bold,
      color: context.ccColorScheme.onSurface.withValues(alpha: 0.8),
      shadows: isDark
          ? [
              Shadow(
                color: context.ccColorScheme.onSurface.withValues(alpha: 0.25),
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ]
          : null,
    );

    final title = CcText(this.title, maxLines: 1, textStyle: titleStyle);

    if (description == null || description!.isEmpty) {
      return Expanded(child: title);
    }

    final descStyle = context.ccTextTheme.labelSmall?.copyWith(
      color: context.ccColorScheme.onSurface.withValues(alpha: 0.6),
      shadows: isDark
          ? [
              Shadow(
                color: context.ccColorScheme.onSurface.withValues(alpha: 0.2),
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ]
          : null,
    );

    final desc = CcText(description!, maxLines: 2, textStyle: descStyle);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, const CcSpaceXS(), desc],
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
