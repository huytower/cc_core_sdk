import 'package:flutter/material.dart';

import '../../core/layout/cc_window_size_class.dart';

/// Lays [children] out as a column on narrow space and as rows of equal-width
/// columns on wider space.
///
/// The layout follows the **width this widget is given** (Material 3 window
/// size class of its constraints), so it behaves the same inside a pane, next
/// to a navigation rail, or full screen:
///
/// - compact (< 600 dp): single column
/// - medium (600–839 dp): [mediumColumns] per row (default 2)
/// - expanded and wider (≥ 840 dp): [expandedColumns] per row (default 3)
///
/// Example usage:
/// ```dart
/// CcResponsiveFlex(
///   children: [
///     MyWidget1(),
///     MyWidget2(),
///     MyWidget3(),
///   ],
/// )
/// ```
class CcResponsiveFlex extends StatelessWidget {
  /// The children widgets to display.
  final List<Widget> children;

  /// Spacing between children.
  final double spacing;

  /// Run spacing (for wrap layout).
  final double runSpacing;

  /// Alignment for the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// Alignment for the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Whether to use Wrap instead of fixed rows on wider space.
  final bool useWrap;

  /// Columns per row on medium width.
  final int mediumColumns;

  /// Columns per row on expanded width and wider.
  final int expandedColumns;

  const CcResponsiveFlex({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.useWrap = false,
    this.mediumColumns = 2,
    this.expandedColumns = 3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final columns = CcWindowSizeClass.fromWidth(width).select<int>(
          compact: 1,
          medium: mediumColumns,
          expanded: expandedColumns,
        );

        if (columns <= 1) {
          return Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            children: _spaced(children, hasVertical: true),
          );
        }
        return _buildRows(columns);
      },
    );
  }

  Widget _buildRows(int columns) {
    if (useWrap) {
      return Wrap(spacing: spacing, runSpacing: runSpacing, children: children);
    }

    final rows = <Widget>[];
    for (int i = 0; i < children.length; i += columns) {
      final rowChildren = <Widget>[
        for (int j = 0; j < columns; j++)
          Expanded(
            child: i + j < children.length
                ? children[i + j]
                : const SizedBox.shrink(),
          ),
      ];
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            children: _spaced(rowChildren, hasVertical: false),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  List<Widget> _spaced(List<Widget> items, {required bool hasVertical}) {
    if (items.isEmpty) return items;
    final gap = hasVertical
        ? SizedBox(height: spacing)
        : SizedBox(width: spacing);
    return [
      for (int i = 0; i < items.length; i++) ...[
        items[i],
        if (i < items.length - 1) gap,
      ],
    ];
  }
}
