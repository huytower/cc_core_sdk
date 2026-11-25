import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// Reusable Hero Banner card with glassmorphic back-card styling and solid
/// front-card priority.
class CcHeroBannerCard extends StatelessWidget {
  const CcHeroBannerCard({
    super.key,
    required this.title,
    required this.formattedValue,
    required this.subtitle,
    required this.valueIcon,
    this.bannerIcon,
    this.bannerIconAsset,
    required this.color,
    required this.hasFront,
    this.onTap,
    this.onSwap,
  });

  final String title;
  final String formattedValue;
  final String subtitle;
  final IconData valueIcon;
  final IconData? bannerIcon;
  final String? bannerIconAsset;
  final Color color;
  final bool hasFront;
  final VoidCallback? onTap;
  final VoidCallback? onSwap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;

    return CcBouncing(
      onTap: hasFront ? onTap : onSwap,
      borderRadius: context.brXl,
      child: Stack(
        children: [
          if (!hasFront)
            const Positioned.fill(child: CcGlassyGradientBackground()),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: context.respPadding(CcPaddingParams.SPACE_LG),
              vertical: context.respPadding(CcPaddingParams.SPACE_LG),
            ),
            decoration: BoxDecoration(
              color: hasFront ? color : color.withValues(alpha: 0.1),
              borderRadius: context.brXl,
              border: hasFront ? null : context.borderSubtle,
              boxShadow: hasFront
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.25),
                        blurRadius: context.respDim(20),
                        offset: Offset(0, context.respDim(10)),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Expanded(child: _buildInfoColumn(context, scheme)),
                const CcSpaceLG(),
                if (hasFront && onSwap != null) ...[
                  _buildSwapAction(context, scheme),
                  const CcSpaceSM(),
                ],
                _buildBannerIcon(context, scheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CcText(
          title,
          textStyle: context.ccTextTheme.labelMedium?.copyWith(
            color: scheme.onPrimary.withValues(alpha: 0.85),
          ),
        ),
        const CcSpaceXS(),
        Row(
          children: [
            Icon(
              valueIcon,
              color: scheme.onPrimary.withValues(alpha: 0.8),
              size: context.respIconSize(baseSize: 18),
            ),
            const CcSpaceXS(),
            CcText(
              formattedValue,
              textStyle: context.ccTextTheme.headlineMedium?.copyWith(
                color: scheme.onPrimary,
                fontWeight: CcTypographyParams.bold,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const CcSpaceXS(),
        CcText(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textStyle: context.ccTextTheme.labelSmall?.copyWith(
            color: scheme.onPrimary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSwapAction(BuildContext context, ColorScheme scheme) {
    return CcIconButton.bouncing(
      onTap: onSwap!,
      icon: Icon(
        Icons.swap_vert_rounded,
        color: scheme.onPrimary.withValues(alpha: 0.6),
        size: context.respIconSize(baseSize: 20),
      ),
      width: context.respDim(32),
      height: context.respDim(32),
    );
  }

  Widget _buildBannerIcon(BuildContext context, ColorScheme scheme) {
    return Container(
      padding: EdgeInsets.all(context.respDim(6)),
      decoration: BoxDecoration(
        color: scheme.onPrimary.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: bannerIconAsset != null
          ? Image.asset(
              bannerIconAsset!,
              color: scheme.onPrimary,
              width: context.respIconSize(baseSize: 16),
              height: context.respIconSize(baseSize: 16),
            )
          : CcIconToken(
              bannerIcon ?? Icons.help_outline,
              color: scheme.onPrimary,
              size: 16,
            ),
    );
  }
}
