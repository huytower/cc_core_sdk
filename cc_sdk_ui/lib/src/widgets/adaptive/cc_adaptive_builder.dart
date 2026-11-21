import 'package:flutter/widgets.dart';

import '../../core/layout/cc_window_size_class.dart';

/// Builds a different layout per Material 3 window size class.
///
/// The class is measured from the **width this widget is given** (via
/// [LayoutBuilder]), not the whole screen, so the same widget adapts correctly
/// inside a pane of a list–detail layout, next to a navigation rail, or in a
/// resizable web/desktop window. If the parent gives an unbounded width (e.g.
/// inside a horizontal scroll view) it falls back to the window width.
///
/// Only [compact] is required. A class without a builder uses the nearest
/// narrower class that has one, so supplying `compact` + `expanded` gives
/// compact/medium → compact layout, expanded/large/extraLarge → expanded.
///
/// ```dart
/// CcAdaptiveBuilder(
///   compact: (context) => const ItemList(),
///   expanded: (context) => const Row(
///     children: [Expanded(child: ItemList()), Expanded(child: ItemDetail())],
///   ),
/// )
/// ```
class CcAdaptiveBuilder extends StatelessWidget {
  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? expanded;
  final WidgetBuilder? large;
  final WidgetBuilder? extraLarge;

  const CcAdaptiveBuilder({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final builder = CcWindowSizeClass.fromWidth(width)
            .select<WidgetBuilder>(
              compact: compact,
              medium: medium,
              expanded: expanded,
              large: large,
              extraLarge: extraLarge,
            );
        return builder(context);
      },
    );
  }
}
