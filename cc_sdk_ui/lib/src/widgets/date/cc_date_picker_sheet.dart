import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A date picker in a bottom sheet: a month header (tap it to pick a year),
/// [CcCalendarMonthGrid], and Cancel / OK. Returns the picked date, or `null`
/// when cancelled or dismissed.
///
/// Month name, weekday initials and the button labels come from
/// [MaterialLocalizations], so the app's Material localizations decide the
/// language; no strings are passed in.
///
/// ```dart
/// final picked = await CcDatePickerSheet.show(
///   context,
///   initialDate: date,
///   firstDate: DateTime(2020),
///   lastDate: DateTime.now(),
/// );
/// ```
class CcDatePickerSheet extends StatefulWidget {
  const CcDatePickerSheet({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.firstDayOfWeekIndex,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  /// See [CcCalendarMonthGrid.firstDayOfWeekIndex].
  final int? firstDayOfWeekIndex;

  /// Opens the picker with [CcAdaptiveBottomSheet].
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    int? firstDayOfWeekIndex,
  }) {
    return CcAdaptiveBottomSheet.show<DateTime>(
      context: context,
      backgroundColor: null,
      builder: (_) => CcDatePickerSheet(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        firstDayOfWeekIndex: firstDayOfWeekIndex,
      ),
    );
  }

  @override
  State<CcDatePickerSheet> createState() => _CcDatePickerSheetState();
}

class _CcDatePickerSheetState extends State<CcDatePickerSheet> {
  late DateTime _selectedDate;
  late DateTime _viewedMonth;
  bool _hasYearPickerOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _viewedMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  bool get _canGoPrevious =>
      _viewedMonth.year > widget.firstDate.year ||
      (_viewedMonth.year == widget.firstDate.year &&
          _viewedMonth.month > widget.firstDate.month);

  bool get _canGoNext =>
      _viewedMonth.year < widget.lastDate.year ||
      (_viewedMonth.year == widget.lastDate.year &&
          _viewedMonth.month < widget.lastDate.month);

  void _shiftMonth(int delta) => setState(() {
    _viewedMonth = DateTime(_viewedMonth.year, _viewedMonth.month + delta);
  });

  void _pickYear(int year) {
    var month = _viewedMonth.month;
    if (year == widget.lastDate.year && month > widget.lastDate.month) {
      month = widget.lastDate.month;
    }
    if (year == widget.firstDate.year && month < widget.firstDate.month) {
      month = widget.firstDate.month;
    }
    setState(() {
      _viewedMonth = DateTime(year, month);
      _hasYearPickerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CcPickerSheetFrame(
      header: _buildHeader(context),
      body: _hasYearPickerOpen
          ? CcYearGrid(
              firstYear: widget.firstDate.year,
              lastYear: widget.lastDate.year,
              selectedYear: _viewedMonth.year,
              onYearTap: _pickYear,
            )
          : CcCalendarMonthGrid(
              month: _viewedMonth,
              selectedDate: _selectedDate,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              firstDayOfWeekIndex: widget.firstDayOfWeekIndex,
              onDateTap: (date) => setState(() => _selectedDate = date),
            ),
      onConfirm: () => Navigator.of(context).pop(_selectedDate),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final scheme = context.ccColorScheme;
    final localizations = MaterialLocalizations.of(context);
    final arrowSize = context.respIconSize(baseSize: 18);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primaryContainer],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.respDim(12)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _canGoPrevious ? () => _shiftMonth(-1) : null,
            tooltip: localizations.previousMonthTooltip,
            icon: Icon(
              Icons.chevron_left_rounded,
              color: scheme.onPrimary,
              size: arrowSize,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Expanded(
            child: CcBouncing(
              onTap: () =>
                  setState(() => _hasYearPickerOpen = !_hasYearPickerOpen),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CcText(
                    localizations.formatMonthYear(_viewedMonth),
                    maxLines: 1,
                    align: Alignment.center,
                    textStyle: context.ccTextTheme.labelLarge?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: CcTypographyParams.bold,
                    ),
                  ),
                  const CcSpaceXS(),
                  Icon(
                    _hasYearPickerOpen
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                    color: scheme.onPrimary,
                    size: context.respIconSize(baseSize: 20),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: _canGoNext ? () => _shiftMonth(1) : null,
            tooltip: localizations.nextMonthTooltip,
            icon: Icon(
              Icons.chevron_right_rounded,
              color: scheme.onPrimary,
              size: arrowSize,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
