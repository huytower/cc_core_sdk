import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A scrollable 4-column grid of the years [firstYear]–[lastYear], with
/// [selectedYear] filled, as used by [CcDatePickerSheet].
///
/// ```dart
/// CcYearGrid(firstYear: 2020, lastYear: 2030, selectedYear: 2026, onYearTap: jumpTo)
/// ```
class CcYearGrid extends StatelessWidget {
  const CcYearGrid({
    super.key,
    required this.firstYear,
    required this.lastYear,
    required this.selectedYear,
    required this.onYearTap,
  });

  final int firstYear;
  final int lastYear;
  final int selectedYear;
  final ValueChanged<int> onYearTap;

  @override
  Widget build(BuildContext context) {
    final count = lastYear - firstYear + 1;
    return Container(
      height: context.respDim(230),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 40,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: count < 0 ? 0 : count,
        itemBuilder: (context, index) => _buildYear(context, firstYear + index),
      ),
    );
  }

  Widget _buildYear(BuildContext context, int year) {
    final scheme = context.ccColorScheme;
    final hasSelected = year == selectedYear;
    return CcBouncing(
      onTap: () => onYearTap(year),
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
