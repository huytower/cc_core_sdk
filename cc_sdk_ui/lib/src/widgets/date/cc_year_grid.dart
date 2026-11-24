import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A scrollable grid of the years [firstYear]–[lastYear] ([columns] per row),
/// with [selectedYear] filled and scrolled into view when it opens. Used by
/// [CcDatePickerSheet] and [CcYearPickerSheet].
///
/// Its height is capped at 40 % of the window so it does not fill a tablet.
///
/// ```dart
/// CcYearGrid(firstYear: 2020, lastYear: 2030, selectedYear: 2026, onYearTap: jumpTo)
/// ```
class CcYearGrid extends StatefulWidget {
  const CcYearGrid({
    super.key,
    required this.firstYear,
    required this.lastYear,
    required this.selectedYear,
    required this.onYearTap,
    this.columns = 4,
  });

  final int firstYear;
  final int lastYear;
  final int selectedYear;
  final ValueChanged<int> onYearTap;
  final int columns;

  static const double _rowExtent = 40;
  static const double _rowGap = 8;

  @override
  State<CcYearGrid> createState() => _CcYearGridState();
}

class _CcYearGridState extends State<CcYearGrid> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Start with the row above the selected year at the top, so the
    // selection is visible with a little context.
    final row = (widget.selectedYear - widget.firstYear) ~/ widget.columns;
    final topRow = row > 1 ? row - 1 : 0;
    _scrollController = ScrollController(
      initialScrollOffset:
          topRow * (CcYearGrid._rowExtent + CcYearGrid._rowGap),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.lastYear - widget.firstYear + 1;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.4;
    return Container(
      height: context.respDim(230).clamp(0, maxHeight).toDouble(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.columns,
          mainAxisExtent: CcYearGrid._rowExtent,
          crossAxisSpacing: 8,
          mainAxisSpacing: CcYearGrid._rowGap,
        ),
        itemCount: count < 0 ? 0 : count,
        itemBuilder: (context, index) =>
            _buildYear(context, widget.firstYear + index),
      ),
    );
  }

  Widget _buildYear(BuildContext context, int year) {
    final scheme = context.ccColorScheme;
    final hasSelected = year == widget.selectedYear;
    return CcBouncing(
      onTap: () => widget.onYearTap(year),
      borderRadius: context.brLg,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: hasSelected ? scheme.primary : Colors.transparent,
          borderRadius: context.brLg,
          border: Border.all(
            color: hasSelected
                ? scheme.primary
                : scheme.primary.withValues(alpha: 0.2),
            width: hasSelected ? 1.5 : 1.0,
          ),
        ),
        child: Center(
          child: CcText(
            '$year',
            align: Alignment.center,
            textStyle: context.ccTextTheme.bodyMedium?.copyWith(
              fontWeight: hasSelected
                  ? CcTypographyParams.bold
                  : CcTypographyParams.regular,
              color: hasSelected ? scheme.onPrimary : scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
