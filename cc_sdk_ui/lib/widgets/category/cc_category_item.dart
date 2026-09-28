import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

class CcCategoryItem extends StatelessWidget {
  const CcCategoryItem({
    super.key,
    required this.iconCode,
    this.iconFamily,
    required this.nameKey,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
    this.width,
  });

  final int iconCode;
  final String? iconFamily;
  final String nameKey;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    final effectiveActiveColor = activeColor ?? scheme.primary;

    return CcInteractBtnWrapper(
      onTap: onTap,
      isBouncing: true,
      useDebounce: false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isSelected)
            Positioned.fill(
              child: CcGlassyGradientBackground(
                centerColor: effectiveActiveColor.withValues(alpha: 0.04),
                endColor: effectiveActiveColor.withValues(alpha: 0.08),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: width ?? context.respDim(75),
            decoration: BoxDecoration(
              color: isSelected
                  ? effectiveActiveColor.withValues(alpha: 0.02)
                  : scheme.onSurface.withValues(alpha: 0.02),
              borderRadius: context.brLg,
              border: Border.all(
                color: isSelected
                    ? effectiveActiveColor.withValues(alpha: 0.04)
                    : scheme.onSurface.withValues(alpha: 0.02),
                width: context.respDim(1),
              ),
            ),
            child: CcPadding(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCategoryIcon(context, isSelected, effectiveActiveColor),
                  const CcSpaceXS(),
                  CcText(
                    el.tr(nameKey),
                    textAlign: TextAlign.center,
                    align: Alignment.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textStyle: context.ccTextTheme.labelSmall?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? effectiveActiveColor
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              4,
              6,
              6,
              4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(
    BuildContext context,
    bool isSelected,
    Color activeColor,
  ) {
    final scheme = context.ccColorScheme;

    return Container(
      width: context.respDim(35),
      height: context.respDim(35),
      decoration: BoxDecoration(
        color: isSelected
            ? activeColor.withValues(alpha: 0.04)
            : scheme.onSurface.withValues(alpha: 0.02),
        borderRadius: context.brMd,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Positioned.fill(
              child: CcGlassyGradientIcon(
                centerColor: activeColor.withValues(alpha: 0.08),
                endColor: activeColor.withValues(alpha: 0.16),
              ),
            ),
          CcIcon(
            icon: iconDataFromCode(iconCode, fontFamily: iconFamily),
            size: context.respIconSize(baseSize: 18),
            color: isSelected ? activeColor : scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
