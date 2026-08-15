import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

class CcCategory extends StatelessWidget {
  const CcCategory({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isCategory,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCategory;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    return CcInkWell(
      onTap: onTap,
      borderRadius: context.brLg,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isSelected)
            Positioned.fill(
              child: CcGlassyGradientBackground(
                centerColor: activeColor.withAlpha(30),
                endColor: activeColor.withAlpha(50),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: context.respDim(68),
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor.withAlpha(10)
                  : scheme.onSurface.withAlpha(isCategory ? 5 : 10),
              borderRadius: context.brLg,
              border: Border.all(
                color: isSelected
                    ? activeColor.withAlpha(20)
                    : scheme.onSurface.withAlpha(isCategory ? 5 : 10),
                width: context.respDim(1),
              ),
            ),
            child: CcPadding(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _IconContainer(
                    icon: icon,
                    isSelected: isSelected,
                    isCategory: isCategory,
                    activeColor: activeColor,
                  ),
                  const CcSpaceXS(),
                  CcText(
                    label,
                    textAlign: TextAlign.center,
                    align: Alignment.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textStyle: context.ccTextTheme.labelSmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? activeColor
                          : scheme.onSurfaceVariant.withValues(alpha: isCategory ? 0.6 : 1.0),
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
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({
    required this.icon,
    required this.isSelected,
    required this.isCategory,
    required this.activeColor,
  });

  final IconData icon;
  final bool isSelected;
  final bool isCategory;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    return Container(
      width: context.respDim(35),
      height: context.respDim(35),
      decoration: BoxDecoration(
          color: isSelected
                  ? activeColor.withValues(alpha: 20)
                  : scheme.onSurface.withAlpha(10),
        borderRadius: context.brMd,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Positioned.fill(
              child: CcGlassyGradientIcon(
                centerColor: activeColor.withAlpha(30),
                endColor: activeColor.withAlpha(50),
              ),
            ),
          Icon(
            icon,
            size: context.respIconSize(baseSize: 18),
              color: isSelected
                  ? activeColor
                  : scheme.onSurfaceVariant.withValues(alpha: isCategory ? 0.5 : 1.0),
          ),
        ],
      ),
    );
  }
}
