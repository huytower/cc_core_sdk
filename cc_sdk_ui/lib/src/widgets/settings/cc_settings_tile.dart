import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// One row of a settings list: a tinted icon, a [label] with an optional
/// [subtitle], and on the right either [trailingWidget] or an optional
/// [trailingLabel] plus a chevron. A [badge] can sit on the bottom-right.
///
/// Group rows with [CcSettingsGroup].
///
/// ```dart
/// CcSettingsTile(
///   icon: Icons.language,
///   label: 'Language',
///   trailingLabel: 'English',
///   onTap: openLanguagePicker,
/// )
/// ```
class CcSettingsTile extends StatelessWidget {
  const CcSettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.trailingLabel,
    this.trailingWidget,
    this.hasChevron = true,
    this.badge,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  /// Short value shown before the chevron (ignored with [trailingWidget]).
  final String? trailingLabel;

  /// Replaces [trailingLabel] and the chevron (a switch, a spinner, ...).
  final Widget? trailingWidget;
  final bool hasChevron;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final edge =
        context.respPadding(CcPaddingParams.SPACE_LG) - context.respDim(4);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CcBouncing(
          onTap: onTap,
          child: CcSymmetricPadding(
            horizontal: CcPaddingParams.SPACE_LG,
            vertical: CcPaddingParams.SPACE_LG,
            child: Row(
              children: [
                _buildIcon(context),
                const CcSpaceLG(),
                Expanded(child: _buildTexts(context)),
                _buildTrailing(context),
              ],
            ),
          ),
        ),
        if (badge != null) Positioned(right: edge, bottom: edge, child: badge!),
      ],
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.respDim(10)),
      decoration: BoxDecoration(
        color: context.ccColorScheme.primary.withValues(alpha: 0.08),
        borderRadius: context.brMd,
      ),
      child: CcIconToken(icon, size: 22),
    );
  }

  Widget _buildTexts(BuildContext context) {
    final scheme = context.ccColorScheme;
    final style = context.ccTextTheme.bodySmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CcText(
          label,
          textStyle: style?.copyWith(
            fontWeight: FontWeight.w500,
            color: scheme.onSurface,
          ),
        ),
        if (subtitle != null) ...[
          const CcSpaceXS(),
          CcText(
            subtitle!,
            textStyle: style?.copyWith(
              color: scheme.onSurfaceVariant.withAlpha(70),
            ),
            maxLines: 2,
          ),
        ],
      ],
    );
  }

  Widget _buildTrailing(BuildContext context) {
    final trailing = trailingWidget;
    if (trailing != null) return trailing;
    final scheme = context.ccColorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trailingLabel != null) ...[
          const CcSpaceXS(),
          CcText(
            trailingLabel!,
            textStyle: context.ccTextTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (hasChevron)
          Icon(
            Icons.chevron_right_rounded,
            size: context.respIconSize(baseSize: 20),
            color: scheme.outline.withAlpha(50),
          ),
      ],
    );
  }
}
