import 'package:flutter/widgets.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';

/// Flows [children] across [columns] equal-width columns, left to right then
/// top to bottom (item 0 → column 0, item 1 → column 1, …, item `columns` →
/// column 0 again).
///
/// Unlike a grid it does not need a fixed item height: every column is a plain
/// stack, so items of different heights (expandable cards, wrapped text) are
/// laid out as they are. Meant to sit inside a scroll view. The column count
/// is fixed — a lone item keeps its 1/[columns] width instead of stretching.
///
/// Use it together with `CcTwoColumn.shouldUse` / `CcMaxWidth` for list pages
/// on a landscape tablet; phones and portrait tablets keep their list.
class CcMultiColumn extends StatelessWidget {
  const CcMultiColumn({
    super.key,
    required this.children,
    this.columns = 3,
    this.columnGap,
    this.rowGap = 0,
  }) : assert(columns > 0);

  final List<Widget> children;
  final int columns;

  /// Space between columns; defaults to the small spacing token.
  final double? columnGap;

  /// Space between items of the same column. 0 when the items carry their own
  /// bottom margin.
  final double rowGap;

  @override
  Widget build(BuildContext context) {
    final gap = columnGap ?? context.respPadding(CcPaddingParams.SPACE_SM);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var c = 0; c < columns; c++) ...[
          if (c > 0) SizedBox(width: gap),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = c; i < children.length; i += columns) ...[
                  if (i > c && rowGap > 0) SizedBox(height: rowGap),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
