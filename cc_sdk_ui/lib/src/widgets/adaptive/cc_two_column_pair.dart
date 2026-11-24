import 'package:flutter/widgets.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import 'cc_two_column.dart';

/// One or two cards of equal rank (for example "this month | last month").
///
/// Where [CcTwoColumn.shouldUse] holds (a tablet held sideways) they sit side
/// by side, each taking half the row; a lone card keeps its half instead of
/// stretching across the row. Elsewhere (phones, portrait tablets) they stack
/// top to bottom. The gap is the same both ways.
///
/// ```dart
/// CcTwoColumnPair(children: [IncomeCard(), ExpenseCard()])
/// ```
class CcTwoColumnPair extends StatelessWidget {
  const CcTwoColumnPair({super.key, required this.children, this.gap})
    : assert(children.length <= 2, 'CcTwoColumnPair takes one or two children');

  /// One or two widgets, in left-to-right / top-to-bottom order.
  final List<Widget> children;

  /// Space between the two; defaults to the large spacing token.
  final double? gap;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    final space = gap ?? context.respPadding(CcPaddingParams.SPACE_LG);

    if (!CcTwoColumn.shouldUse(context)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: space),
            children[i],
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: children.first),
        SizedBox(width: space),
        Expanded(
          child: children.length > 1 ? children[1] : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
