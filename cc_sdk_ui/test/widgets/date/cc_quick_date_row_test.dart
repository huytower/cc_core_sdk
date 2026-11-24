import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('today / yesterday / calendar call back', (tester) async {
    final picked = <DateTime>[];
    var calendarTaps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CcQuickDateRow(
            label: 'Date',
            todayLabel: 'Today',
            yesterdayLabel: 'Yesterday',
            selectedDate: DateTime.now(),
            onDateSelected: picked.add,
            onCalendarTap: () => calendarTaps++,
            activeColor: Colors.green,
          ),
        ),
      ),
    );

    expect(find.text('Date', findRichText: true), findsOneWidget);
    await tester.tap(find.text('Today', findRichText: true));
    await tester.tap(find.text('Yesterday', findRichText: true));
    await tester.tap(find.byIcon(Icons.calendar_month));
    await tester.pumpAndSettle();

    final today = DateTime.now();
    expect(DateUtils.isSameDay(picked[0], today), isTrue);
    expect(
      DateUtils.isSameDay(picked[1], today.subtract(const Duration(days: 1))),
      isTrue,
    );
    expect(calendarTaps, 1);
  });
}
