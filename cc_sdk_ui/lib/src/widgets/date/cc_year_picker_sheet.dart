import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// Bottom sheet for picking one year from [firstYear]–[lastYear] (a birth
/// year, a model year, ...): a [CcYearGrid] in a [CcPickerSheetFrame] with
/// Cancel / OK. Returns the year, or `null` when cancelled.
///
/// ```dart
/// final year = await CcYearPickerSheet.show(
///   context,
///   title: 'Your birth year',
///   initialYear: 1995,
///   firstYear: 1950,
///   lastYear: 2015,
/// );
/// ```
class CcYearPickerSheet extends StatefulWidget {
  const CcYearPickerSheet({
    super.key,
    required this.title,
    required this.initialYear,
    required this.firstYear,
    required this.lastYear,
  });

  final String title;
  final int initialYear;
  final int firstYear;
  final int lastYear;

  static Future<int?> show(
    BuildContext context, {
    required String title,
    required int initialYear,
    required int firstYear,
    required int lastYear,
  }) {
    return CcAdaptiveBottomSheet.show<int>(
      context: context,
      builder: (_) => CcYearPickerSheet(
        title: title,
        initialYear: initialYear,
        firstYear: firstYear,
        lastYear: lastYear,
      ),
    );
  }

  @override
  State<CcYearPickerSheet> createState() => _CcYearPickerSheetState();
}

class _CcYearPickerSheetState extends State<CcYearPickerSheet> {
  late int _selectedYear = widget.initialYear;

  @override
  Widget build(BuildContext context) {
    return CcPickerSheetFrame(
      title: widget.title,
      body: CcYearGrid(
        firstYear: widget.firstYear,
        lastYear: widget.lastYear,
        selectedYear: _selectedYear,
        columns: 3,
        onYearTap: (year) => setState(() => _selectedYear = year),
      ),
      onConfirm: () => Navigator.of(context).pop(_selectedYear),
    );
  }
}
