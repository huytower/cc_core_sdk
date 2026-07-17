import 'dart:ui';

import 'package:cc_sdk_ui/widgets/icon/cc_leading_icon.dart';
import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_typography_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../button/cc_icon_button.dart';
import '../space/cc_space.dart';
import '../text/cc_text.dart';

/// A frosted, semi-transparent list banner with a leading icon button,
/// a two-column content row (title + description), and a trailing suffix icon.
///
/// Unlike [CcFrostedBanner] (which centers a single badge + message), this
/// widget is built for list/setting rows: a tappable leading action, a
/// title/description pair, and an optional trailing affordance (chevron, etc.).
///
/// This component is project-blind and state-agnostic.
///
/// Usage:
/// ```dart
/// CcListBanner(
///   leadingIcon: Icons.notifications_rounded,
///   onLeadingTap: () {},
///   title: 'Reminders',
///   description: 'Daily spending alerts',
///   showChevron: true,
/// )
/// ```
class CcListBanner extends StatelessWidget {
  const CcListBanner({
    super.key,
    this.leadingIcon,
    this.onLeadingTap,
    required this.title,
    this.description,
    this.descriptionIcon,
    this.descriptionIconColor,
    this.suffixIcon,
    this.onSuffixTap,
    this.color,
    this.onTap,
    this.showChevron = true,
  });

  final IconData? leadingIcon;
  final VoidCallback? onLeadingTap;
  final String title;
  final String? description;

  /// Optional icon shown at the start of the [description] row (e.g. a
  /// fixed-price marker). Rendered inline before the description text.
  final IconData? descriptionIcon;
  final Color? descriptionIconColor;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final Color? color;
  final VoidCallback? onTap;

  /// When true (default), a trailing chevron is shown if no explicit
  /// [suffixIcon] is provided.
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.respDim(16)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: _buildDecoration(context),
          child: _buildInkWell(context),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    final isDark = context.isDarkMode;
    final scheme = context.ccColorScheme;
    final color = this.color ?? scheme.primary;

    final gradientAlpha = isDark ? 0.8 : 0.2;
    final borderAlpha = 0.1;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(context.respDim(16)),
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
    final isDarkMode = context.isDarkMode;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.respDim(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.respDim(6),
          vertical: context.respDim(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CcLeadingIcon(
              bgColor: isDarkMode
                  ? context.ccColorScheme.onSurface
                  : context.ccColorScheme.surface,
              icon: Icon(
                leadingIcon,
                size: context.respIconSize(baseSize: 22),
                color: color,
              ),
            ),
            const CcSpaceXS(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(context),
                  if (description != null && description!.isNotEmpty) ...[
                    const CcSpaceXS(),
                    _buildDesc(context),
                  ],
                ],
              ),
            ),
            if (suffixIcon != null || showChevron) ...[
              const CcSpaceXS(),
              CcIconButton.bouncing(
                onTap: onSuffixTap ?? () {},
                icon: Icon(
                  suffixIcon ?? Icons.chevron_right,
                  size: context.respIconSize(baseSize: 20),
                  color: context.ccColorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return CcText(
      title,
      maxLines: 1,
      textStyle: context.ccTextTheme.bodyMedium?.copyWith(
        fontWeight: CcTypographyParams.bold,
        color: context.ccColorScheme.onSurface.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildDesc(BuildContext context) {
    final text = CcText(
      description!,
      maxLines: 2,
      textStyle: context.ccTextTheme.labelSmall?.copyWith(
        color: context.ccColorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );

    if (descriptionIcon == null) return text;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          descriptionIcon,
          size: context.respIconSize(baseSize: 14),
          color:
              descriptionIconColor ??
              context.ccColorScheme.primary.withValues(alpha: 0.6),
        ),
        const CcSpaceXS(),
        Expanded(child: text),
      ],
    );
  }
}
