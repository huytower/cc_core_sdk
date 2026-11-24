import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A labelled date field with one-tap "today" / "yesterday" buttons and a
/// calendar icon (for a full picker such as [CcDatePickerSheet]).
///
/// Lays out as a [Wrap], so in a narrow column the buttons drop to the next
/// line instead of overflowing.
///
/// ```dart
/// CcQuickDateRow(
///   label: 'Date',
///   todayLabel: 'Today',
///   yesterdayLabel: 'Yesterday',
///   selectedDate: date,
///   onDateSelected: controller.setDate,
///   onCalendarTap: controller.pickDate,
///   activeColor: context.ccColorScheme.primary,
/// )
/// ```
class CcQuickDateRow extends StatelessWidget {
  const CcQuickDateRow({
    super.key,
    required this.label,
    required this.todayLabel,
    required this.yesterdayLabel,
    required this.selectedDate,
    required this.onDateSelected,
    required this.activeColor,
    this.onCalendarTap,
  });

  final String label;
  final String todayLabel;
  final String yesterdayLabel;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback? onCalendarTap;

  /// Colour of the selected quick button.
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    final now = DateTime.now();

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: context.respDim(8),
      runSpacing: context.respDim(8),
      children: [
        CcText(
          label,
          textStyle: context.ccTextTheme.labelMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuickDateButton(context, todayLabel, now),
            const CcSpaceSM(),
            _buildQuickDateButton(
              context,
              yesterdayLabel,
              now.subtract(const Duration(days: 1)),
            ),
            const CcSpaceSM(),
            CcBouncing(
              onTap: onCalendarTap,
              child: Icon(
                Icons.calendar_month,
                size: context.respIconSize(baseSize: 18),
                color: scheme.outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickDateButton(
    BuildContext context,
    String text,
    DateTime date,
  ) {
    final scheme = context.ccColorScheme;
    final hasSelected = DateUtils.isSameDay(selectedDate, date);
    return CcBouncing(
      onTap: () => onDateSelected(date),
      borderRadius: context.brLg,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: context.respPadding(CcPaddingParams.SPACE_MD),
          vertical: context.respPadding(CcPaddingParams.SPACE_XS),
        ),
        decoration: BoxDecoration(
          color: hasSelected
              ? activeColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: context.brLg,
          border: Border.all(
            color: hasSelected ? activeColor : scheme.outlineVariant,
            width: hasSelected ? 1.5 : 1,
          ),
        ),
        child: CcText(
          text,
          textStyle: context.ccTextTheme.labelMedium?.copyWith(
            color: hasSelected ? activeColor : scheme.onSurfaceVariant,
            fontWeight: hasSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
