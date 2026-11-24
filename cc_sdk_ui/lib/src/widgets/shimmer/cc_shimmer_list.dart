import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_border_radius.dart';
import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../space/cc_space.dart';
import 'cc_shimmer.dart';

/// A horizontal row of shimmering tiles (an icon box above a label line),
/// shown while a horizontal picker or carousel loads.
///
/// Every size is a design size scaled with the window; leave a value `null`
/// to use the default.
///
/// ```dart
/// hasLoading ? const CcShimmerList() : MyPickerRow(items: items)
/// ```
class CcShimmerList extends StatelessWidget {
  const CcShimmerList({
    super.key,
    this.itemCount = 5,
    this.height,
    this.itemWidth,
    this.verticalPadding,
    this.horizontalPadding,
    this.itemPadding,
    this.separator,
    this.labelWidth,
  });

  /// Number of placeholder tiles.
  final int itemCount;

  /// Height of the row. Defaults to `respDim(80)`.
  final double? height;

  /// Width of each tile. Defaults to `respDim(85)`.
  final double? itemWidth;

  /// Vertical padding of the row. Defaults to 0.
  final double? verticalPadding;

  /// Horizontal padding of the row. Defaults to the small page padding.
  final double? horizontalPadding;

  /// Padding inside each tile. Defaults to `respDim(10)` on every side.
  final EdgeInsetsGeometry? itemPadding;

  /// Widget between tiles. Defaults to [CcSpaceSM].
  final Widget? separator;

  /// Width of the shimmering label line. Defaults to `respDim(40)`.
  final double? labelWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? context.respDim(80),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal:
              horizontalPadding ?? context.respPadding(CcPaddingParams.PAGE_SM),
          vertical: verticalPadding ?? 0,
        ),
        itemCount: itemCount,
        separatorBuilder: (context, index) => separator ?? const CcSpaceSM(),
        itemBuilder: (context, index) => _buildTile(context),
      ),
    );
  }

  Widget _buildTile(BuildContext context) {
    return Container(
      width: itemWidth ?? context.respDim(85),
      padding: itemPadding ?? EdgeInsets.all(context.respDim(10)),
      decoration: BoxDecoration(
        color: context.ccColorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: context.brLg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CcShimmer(
            width: context.respDim(35),
            height: context.respDim(35),
            borderRadius: context.brMd,
          ),
          const CcSpaceXS(),
          CcShimmer(
            width: labelWidth ?? context.respDim(40),
            height: context.respDim(10),
            borderRadius: context.brXs,
          ),
        ],
      ),
    );
  }
}
