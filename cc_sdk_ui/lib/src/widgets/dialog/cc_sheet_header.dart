import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// The coloured top of a bottom sheet: a primary-colour gradient with rounded
/// top corners, an optional leading [icon], a [title] (up to [titleMaxLines]
/// lines, so a question fits), an optional [subtitle] and an optional
/// [trailing] widget (a close or action button).
///
/// ```dart
/// CcSheetHeader(title: 'Review', subtitle: '3 items', trailing: CcCloseButton())
/// ```
class CcSheetHeader extends StatelessWidget {
  const CcSheetHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.titleMaxLines = 3,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final int titleMaxLines;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.respPadding(CcPaddingParams.SPACE_LG)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primaryContainer],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.respDim(16)),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            CcIconToken(
              icon!,
              size: context.respIconSize(baseSize: 20),
              color: scheme.onPrimary,
            ),
            const CcSpaceSM(),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CcText(
                  title,
                  maxLines: titleMaxLines,
                  textStyle: context.ccTextTheme.titleMedium?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: CcTypographyParams.bold,
                  ),
                ),
                if (subtitle != null)
                  CcText(
                    subtitle,
                    textStyle: context.ccTextTheme.labelSmall?.copyWith(
                      color: scheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
