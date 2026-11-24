import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// Bottom sheet for picking a day of the week: the seven names in a 3-column
/// grid inside a [CcPickerSheetFrame] with Cancel / OK. Returns the weekday as
/// [DateTime.monday] (1) ... [DateTime.sunday] (7), or `null` when cancelled.
///
/// [weekdayNames] are the seven full names, Monday first, already translated
/// (Flutter only ships one-letter names, and this package has no `intl`).
///
/// ```dart
/// final day = await CcWeekdayPickerSheet.show(
///   context,
///   title: 'Weekly check day',
///   weekdayNames: names,
///   initialWeekday: DateTime.sunday,
/// );
/// ```
class CcWeekdayPickerSheet extends StatefulWidget {
  const CcWeekdayPickerSheet({
    super.key,
    required this.title,
    required this.weekdayNames,
    required this.initialWeekday,
  }) : assert(weekdayNames.length == DateTime.daysPerWeek);

  final String title;
  final List<String> weekdayNames;
  final int initialWeekday;

  static Future<int?> show(
    BuildContext context, {
    required String title,
    required List<String> weekdayNames,
    required int initialWeekday,
  }) {
    return CcAdaptiveBottomSheet.show<int>(
      context: context,
      builder: (_) => CcWeekdayPickerSheet(
        title: title,
        weekdayNames: weekdayNames,
        initialWeekday: initialWeekday,
      ),
    );
  }

  @override
  State<CcWeekdayPickerSheet> createState() => _CcWeekdayPickerSheetState();
}

class _CcWeekdayPickerSheetState extends State<CcWeekdayPickerSheet> {
  late int _selectedWeekday = widget.initialWeekday;

  @override
  Widget build(BuildContext context) {
    return CcPickerSheetFrame(
      title: widget.title,
      body: _buildGrid(context),
      onConfirm: () => Navigator.of(context).pop(_selectedWeekday),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: context.respPadding(CcPaddingParams.PAGE_MD),
        vertical: context.respPadding(CcPaddingParams.PAGE_SM),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: context.respDim(44),
        crossAxisSpacing: context.respDim(8),
        mainAxisSpacing: context.respDim(8),
      ),
      itemCount: DateTime.daysPerWeek,
      itemBuilder: (context, index) => _buildDay(context, index + 1),
    );
  }

  Widget _buildDay(BuildContext context, int weekday) {
    final scheme = context.ccColorScheme;
    final hasSelected = weekday == _selectedWeekday;
    return Center(
      child: CcBouncing(
        onTap: () => setState(() => _selectedWeekday = weekday),
        borderRadius: context.brLg,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: context.respDim(80),
          height: context.respDim(40),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: hasSelected ? scheme.primary : Colors.transparent,
            borderRadius: context.brLg,
          ),
          child: CcText(
            widget.weekdayNames[weekday - 1],
            align: Alignment.center,
            textStyle: context.ccTextTheme.bodyLarge?.copyWith(
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
