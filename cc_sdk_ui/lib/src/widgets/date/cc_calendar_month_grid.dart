import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// One month as a 6 × 7 grid of days under a row of weekday initials, as used
/// by [CcDatePickerSheet]. Days outside [firstDate]–[lastDate] are dimmed and
/// cannot be tapped; days of the neighbouring months are dimmed too.
///
/// Weekday initials come from [MaterialLocalizations], so no strings are needed.
///
/// ```dart
/// CcCalendarMonthGrid(
///   month: DateTime(2026, 11),
///   selectedDate: picked,
///   firstDate: DateTime(2020),
///   lastDate: DateTime(2030),
///   onDateTap: (date) => setState(() => picked = date),
/// )
/// ```
class CcCalendarMonthGrid extends StatelessWidget {
  const CcCalendarMonthGrid({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateTap,
    this.firstDayOfWeekIndex,
  });

  /// Any date in the month shown.
  final DateTime month;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateTap;

  /// First column of the week, 0 = Sunday ... 6 = Saturday. Defaults to the
  /// locale's ([MaterialLocalizations.firstDayOfWeekIndex]).
  final int? firstDayOfWeekIndex;

  static const int _cellCount = 42;

  /// The 42 dates shown for [month], starting on the week's first day.
  static List<DateTime> daysOf(DateTime month, int firstDayOfWeekIndex) {
    final first = DateTime(month.year, month.month);
    final leading = (first.weekday % 7 - firstDayOfWeekIndex + 7) % 7;
    return List.generate(
      _cellCount,
      (index) => DateTime(first.year, first.month, 1 - leading + index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final firstIndex = firstDayOfWeekIndex ?? localizations.firstDayOfWeekIndex;
    final days = daysOf(month, firstIndex);
    final today = DateTime.now();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildWeekdayLabels(context, localizations, firstIndex),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 40,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: _cellCount,
          itemBuilder: (context, index) =>
              _buildDayCell(context, days[index], today),
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels(
    BuildContext context,
    MaterialLocalizations localizations,
    int firstIndex,
  ) {
    final scheme = context.ccColorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          for (var column = 0; column < 7; column++)
            Expanded(
              child: CcText(
                localizations.narrowWeekdays[(firstIndex + column) % 7],
                align: Alignment.center,
                textStyle: context.ccTextTheme.labelMedium?.copyWith(
                  color: scheme.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime date, DateTime today) {
    final scheme = context.ccColorScheme;
    final hasCurrentMonth =
        date.year == month.year && date.month == month.month;
    final hasSelected = DateUtils.isSameDay(date, selectedDate);
    final hasToday = DateUtils.isSameDay(date, today);
    final hasSelectable = !date.isBefore(firstDate) && !date.isAfter(lastDate);
    final dimmed = scheme.onSurfaceVariant.withValues(alpha: 0.4);

    return CcBouncing(
      onTap: hasSelectable ? () => onDateTap(date) : null,
      borderRadius: context.brLg,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: hasSelected ? scheme.primary : Colors.transparent,
          borderRadius: context.brLg,
          border: Border.all(
            color: hasSelected
                ? scheme.primary
                : hasToday
                ? scheme.primary.withValues(alpha: 0.3)
                : Colors.transparent,
            width: hasSelected || hasToday ? 1.5 : 0,
          ),
        ),
        child: Center(
          child: CcText(
            '${date.day}',
            align: Alignment.center,
            textStyle: context.ccTextTheme.bodyMedium?.copyWith(
              fontWeight: hasSelected
                  ? CcTypographyParams.bold
                  : CcTypographyParams.regular,
              color: hasSelected
                  ? scheme.onPrimary
                  : hasSelectable && hasCurrentMonth
                  ? scheme.onSurface
                  : dimmed,
            ),
          ),
        ),
      ),
    );
  }
}
