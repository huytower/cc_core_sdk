import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

/// Data model for items displayed within [CcCategoryGroupSection].
class CcCategoryGroupItem {
  final String labelKey;
  final int iconCode;
  final String? iconFamily;
  final dynamic originalData; // To pass back the full object on toggle

  const CcCategoryGroupItem({
    required this.labelKey,
    required this.iconCode,
    this.iconFamily,
    this.originalData,
  });
}

/// A horizontal section representing a group of categories with a glassy background
/// and a large watermark icon.
class CcCategoryGroupSection extends StatelessWidget {
  final List<CcCategoryGroupItem> items;
  final bool Function(CcCategoryGroupItem) isEnabled;
  final void Function(CcCategoryGroupItem) onToggle;
  final Color? accentColor;
  final IconData? watermarkIcon;

  const CcCategoryGroupSection({
    super.key,
    required this.items,
    required this.isEnabled,
    required this.onToggle,
    this.accentColor,
    this.watermarkIcon,
  });

  @override
  Widget build(BuildContext context) {
    final primary = accentColor ?? context.ccColorScheme.primary;

    // Use watermarkIcon if provided, else fallback to first item's icon or generic category icon
    final bgIcon =
        watermarkIcon ??
        (items.isNotEmpty
            ? iconDataFromCode(
                items.first.iconCode,
                fontFamily: items.first.iconFamily,
              )
            : Icons.category_rounded);

    return CcSymmetricPadding(
      horizontal: CcPaddingParams.PAGE_SM,
      vertical: CcPaddingParams.SPACE_XS,
      child: ClipRRect(
        borderRadius: context.brXl,
        child: Stack(
          children: [
            // Tinted Background
            Positioned.fill(
              child: Container(color: primary.withValues(alpha: 0.08)),
            ),
            // Watermark Icon
            Positioned(
              right: -context.respDim(20),
              bottom: -context.respDim(20),
              child: Icon(
                bgIcon,
                size: context.respDim(120),
                color: primary.withValues(alpha: 0.1),
              ),
            ),
            // Horizontal Content
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.respDim(18)),
              child: HorizontalFadeScrollView(
                height: context.respDim(45),
                builder: (controller) => ListView.separated(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.respPadding(CcPaddingParams.PAGE_SM),
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const CcSpaceSM(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final enabled = isEnabled(item);
                    return CcCategoryChip(
                      labelKey: item.labelKey,
                      iconCode: item.iconCode,
                      iconFamily: item.iconFamily,
                      isEnabled: enabled,
                      onTap: () => onToggle(item),
                      accentColor: accentColor,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
