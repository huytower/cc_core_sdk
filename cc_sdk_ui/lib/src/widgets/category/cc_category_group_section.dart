import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// A horizontal section representing a group of categories with a glassy background
/// and a large watermark icon.
class CcCategoryGroupSection extends StatelessWidget {
  final List<CcCategoryGroupItem> items;
  final bool Function(CcCategoryGroupItem) hasEnabled;
  final void Function(CcCategoryGroupItem) onToggle;
  final Color? accentColor;
  final IconData? watermarkIcon;

  const CcCategoryGroupSection({
    super.key,
    required this.items,
    required this.hasEnabled,
    required this.onToggle,
    this.accentColor,
    this.watermarkIcon,
  });

  @override
  Widget build(BuildContext context) {
    final primary = accentColor ?? context.ccColorScheme.primary;

    final backgroundIcon =
        watermarkIcon ??
        (items.isNotEmpty
            ? iconDataFromCode(
                items.first.iconCode,
                fontFamily: items.first.iconFamily,
              )
            : Icons.category_rounded);

    return CcPadding(
      ClipRRect(
        borderRadius: BorderRadius.horizontal(left: context.brMd.topLeft),
        child: CcWatermarkBackground(
          icon: backgroundIcon,
          activeColor: primary,
          // The list stretches each chip to its height, so the room around
          // the chips is padding, not extra list height.
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: context.respDim(18)),
            child: CcHorizontalFadeScrollView(
              height: context.respDim(45),
              builder: (controller) => ListView.separated(
                controller: controller,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: context.respPadding(CcPaddingParams.SPACE_SM),
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) => const CcSpaceSM(),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final enabled = hasEnabled(item);
                  return CcCategoryChip(
                    label: item.label,
                    iconCode: item.iconCode,
                    iconFamily: item.iconFamily,
                    hasEnabled: enabled,
                    onTap: () => onToggle(item),
                    accentColor: accentColor,
                  );
                },
              ),
            ),
          ),
        ),
      ),
      CcPaddingParams.SPACE_XS,
      CcPaddingParams.PAGE_SM,
      0,
      CcPaddingParams.SPACE_XS,
    );
  }
}
