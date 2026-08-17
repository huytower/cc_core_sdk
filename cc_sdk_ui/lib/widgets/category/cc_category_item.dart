import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

class CcCategoryItem extends StatelessWidget {
  const CcCategoryItem({
    super.key,
    required this.iconCode,
    required this.iconFamily,
    required this.nameKey,
    required this.isSelected,
    required this.onTap,
  });

  final int iconCode;
  final String? iconFamily;
  final String nameKey;
  final bool isSelected;
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
            const Positioned.fill(child: CcGlassyGradientBackground()),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: context.respDim(50),
            decoration: BoxDecoration(
              color: isSelected
                  ? scheme.primaryContainer.withValues(alpha: 0.1)
                  : scheme.onSurface.withOpacity(0.04),
              borderRadius: context.brLg,
              border: Border.all(
                color: isSelected
                    ? scheme.primary.withOpacity(0.2)
                    : scheme.onSurface.withOpacity(0.08),
                width: context.respDim(1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryIcon(context, isSelected),
                const CcSpaceXS(),
                Text(
                  el.tr(nameKey),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.ccTextTheme.labelSmall?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(BuildContext context, bool isSelected) {
    final scheme = context.ccColorScheme;

    return Container(
      width: context.respDim(32),
      height: context.respDim(32),
      decoration: BoxDecoration(
        color: isSelected
            ? scheme.primary.withOpacity(0.12)
            : scheme.onSurface.withOpacity(0.08),
        borderRadius: context.brMd,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected) const Positioned.fill(child: CcGlassyGradientIcon()),
          CcIcon(
            icon: iconDataFromCode(iconCode, fontFamily: iconFamily),
            size: context.respIconSize(baseSize: 18),
            color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
