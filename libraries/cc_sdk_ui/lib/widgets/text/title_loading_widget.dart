import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/helper/cc_widget_helper.dart';

/// POPULAR WIDGET
/// Skeleton|Shimmer|Waiting|Loading text (Loading text ui), is showing while loading data from API response.
class TitleLoadingWidget extends StatelessWidget {
  const TitleLoadingWidget({Key? key, this.lineWidth, this.lineHeight})
    : super(key: key);

  final double? lineHeight, lineWidth;

  @override
  Widget build(BuildContext c) => getEmptyContainer();

  Widget getEmptyContainer() => SizedBox(
    width: lineWidth ?? 50,
    height: lineHeight ?? 14,
    child: Shimmer.fromColors(
      baseColor: CcBaseColors.neutral5,
      highlightColor: Colors.yellow,
      child: Container(
        width: lineWidth ?? 50,
        height: 12,
        decoration: BoxDecoration(
          color: CcBaseColors.neutral5,
          borderRadius: CcWidgetHelper.getBorderRoundedLarge(),
        ),
      ),
    ),
  );
}
