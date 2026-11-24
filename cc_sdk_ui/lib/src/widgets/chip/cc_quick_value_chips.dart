import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A horizontal, fading strip of tinted chips for picking a common value
/// (amounts, durations, quantities, ...). Shows nothing when [items] is empty.
///
/// ```dart
/// CcQuickValueChips<int>(
///   items: const [CcQuickValue(value: 10, label: '10'), CcQuickValue(value: 20, label: '20')],
///   onSelected: controller.setQuantity,
///   activeColor: context.ccColorScheme.primary,
/// )
/// ```
class CcQuickValueChips<T> extends StatelessWidget {
  const CcQuickValueChips({
    super.key,
    required this.items,
    required this.onSelected,
    required this.activeColor,
    this.padding,
  });

  final List<CcQuickValue<T>> items;
  final ValueChanged<T> onSelected;

  /// Tint of the chips and colour of their labels.
  final Color activeColor;

  /// Padding of the scrolling row.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return CcHorizontalFadeScrollView(
      height: context.respDim(35),
      builder: (scrollController) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        padding: padding,
        child: Row(
          children: [
            for (final item in items)
              Padding(
                padding: EdgeInsets.only(right: context.respDim(8)),
                child: _buildChip(context, item),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, CcQuickValue<T> item) {
    return CcBouncing(
      key: ValueKey('chip_${item.value}'),
      onTap: () => onSelected(item.value),
      borderRadius: context.brLg,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.respPadding(CcPaddingParams.SPACE_LG),
          vertical: context.respPadding(CcPaddingParams.SPACE_XS),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: activeColor.withAlpha(20),
          borderRadius: context.brLg,
        ),
        child: CcText(
          item.label,
          textStyle: context.ccTextTheme.labelMedium?.copyWith(
            color: activeColor,
            fontWeight: CcTypographyParams.semiBold,
          ),
        ),
      ),
    );
  }
}
