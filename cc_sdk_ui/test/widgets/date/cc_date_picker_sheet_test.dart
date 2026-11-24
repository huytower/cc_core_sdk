import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<DateTime?> _openAndRun(
  WidgetTester tester,
  Future<void> Function() interact, {
  int? firstDayOfWeekIndex,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  DateTime? result;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            result = await CcDatePickerSheet.show(
              context,
              initialDate: DateTime(2026, 11, 10),
              firstDate: DateTime(2024, 3, 5),
              lastDate: DateTime(2026, 11, 24),
              firstDayOfWeekIndex: firstDayOfWeekIndex,
            );
          },
          child: const Text('open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open', findRichText: true));
  await tester.pumpAndSettle();
  await interact();
  await tester.pumpAndSettle();
  return result;
}

void main() {
  group('CcCalendarMonthGrid.daysOf', () {
    // 1 November 2026 is a Sunday.
    test('Monday first: six leading October days', () {
      final days = CcCalendarMonthGrid.daysOf(DateTime(2026, 11), 1);
      expect(days.length, 42);
      expect(days.first, DateTime(2026, 10, 26));
      expect(days[6], DateTime(2026, 11, 1));
    });

    test('Sunday first: the month starts the grid', () {
      final days = CcCalendarMonthGrid.daysOf(DateTime(2026, 11), 0);
      expect(days.first, DateTime(2026, 11, 1));
    });
  });

  testWidgets('shows the month from MaterialLocalizations', (tester) async {
    await _openAndRun(tester, () async {
      expect(find.text('November 2026', findRichText: true), findsOneWidget);
      expect(find.text('OK', findRichText: true), findsOneWidget);
      expect(find.text('Cancel', findRichText: true), findsOneWidget);
    });
  });

  testWidgets('tap a day then OK returns it', (tester) async {
    final picked = await _openAndRun(tester, () async {
      await tester.tap(find.text('20', findRichText: true));
      await tester.pump();
      await tester.tap(find.text('OK', findRichText: true));
    });
    expect(picked, DateTime(2026, 11, 20));
  });

  testWidgets('days after lastDate cannot be picked', (tester) async {
    final picked = await _openAndRun(tester, () async {
      await tester.tap(find.text('28', findRichText: true));
      await tester.pump();
      await tester.tap(find.text('OK', findRichText: true));
    });
    expect(picked, DateTime(2026, 11, 10));
  });

  testWidgets('Cancel returns null', (tester) async {
    final picked = await _openAndRun(tester, () async {
      await tester.tap(find.text('Cancel', findRichText: true));
    });
    expect(picked, isNull);
  });

  testWidgets('year grid clamps the month to firstDate', (tester) async {
    await _openAndRun(tester, () async {
      await tester.tap(find.text('November 2026', findRichText: true));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2024', findRichText: true));
      await tester.pumpAndSettle();
      expect(find.text('November 2024', findRichText: true), findsOneWidget);
    });
  });
}
