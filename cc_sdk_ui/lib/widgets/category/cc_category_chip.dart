import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

/// A horizontal chip representing a category with an icon and label.
/// Supports an 'enabled' (selected) state with glassy highlights.
class CcCategoryChip extends StatelessWidget {
  final String labelKey;
  final int iconCode;
  final String? iconFamily;
  final bool isEnabled;
  final VoidCallback onTap;
  final Color? accentColor;

  const CcCategoryChip({
    super.key,
    required this.labelKey,
    required this.iconCode,
    this.iconFamily,
    required this.isEnabled,
    required this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = accentColor ?? context.ccColorScheme.primary;
    final chipBg = isEnabled
        ? primary.withOpacity(0.15)
        : context.ccColorScheme.surfaceContainerHighest;
    final iconColor = isEnabled
        ? primary
        : context.ccColorScheme.onSurfaceVariant;
    final textColor = isEnabled
        ? primary
        : context.ccColorScheme.onSurfaceVariant;

    return CcInkWell(
      onTap: onTap,
      borderRadius: context.brXl,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: context.respDim(12),
          vertical: context.respDim(8),
        ),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: context.brXl,
          border: Border.all(
            color: isEnabled ? primary.withOpacity(0.4) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: Icon(
                isEnabled
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                key: ValueKey(isEnabled),
                size: context.respIconSize(baseSize: 16),
                color: iconColor,
              ),
            ),
            SizedBox(width: context.respDim(6)),
            Icon(
              iconDataFromCode(iconCode, fontFamily: iconFamily),
              size: context.respIconSize(baseSize: 14),
              color: iconColor,
            ),
            const CcSpaceXS(),
            CcText(
              el.tr(labelKey),
              textStyle: context.ccTextTheme.labelMedium?.copyWith(
                color: textColor,
                fontWeight: isEnabled ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
