import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _text(String text) => find.text(text, findRichText: true);

Future<T?> _openAndRun<T>(
  WidgetTester tester,
  Future<T?> Function(BuildContext context) open,
  Future<void> Function() interact,
) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  T? result;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await open(context),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  await interact();
  await tester.pumpAndSettle();
  return result;
}

const _names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

void main() {
  testWidgets('year picker: tap a year, OK returns it', (tester) async {
    final year = await _openAndRun<int>(
      tester,
      (context) => CcYearPickerSheet.show(
        context,
        title: 'Birth year',
        initialYear: 2000,
        firstYear: 1990,
        lastYear: 2010,
      ),
      () async {
        expect(_text('Birth year'), findsOneWidget);
        await tester.tap(_text('2001'));
        await tester.pump();
        await tester.tap(_text('OK'));
      },
    );
    expect(year, 2001);
  });

  testWidgets('year picker: Cancel returns null', (tester) async {
    final year = await _openAndRun<int>(
      tester,
      (context) => CcYearPickerSheet.show(
        context,
        title: 'Birth year',
        initialYear: 2000,
        firstYear: 1990,
        lastYear: 2010,
      ),
      () => tester.tap(_text('Cancel')),
    );
    expect(year, isNull);
  });

  testWidgets('weekday picker: names shown, Sunday is 7', (tester) async {
    final day = await _openAndRun<int>(
      tester,
      (context) => CcWeekdayPickerSheet.show(
        context,
        title: 'Check day',
        weekdayNames: _names,
        initialWeekday: DateTime.monday,
      ),
      () async {
        for (final name in _names) {
          expect(_text(name), findsOneWidget);
        }
        await tester.tap(_text('Sun'));
        await tester.pump();
        await tester.tap(_text('OK'));
      },
    );
    expect(day, DateTime.sunday);
  });

  testWidgets('text input: save is off while blank, returns trimmed text', (
    tester,
  ) async {
    final text = await _openAndRun<String>(
      tester,
      (context) => CcTextInputSheet.show(
        context,
        title: 'Name',
        confirmLabel: 'Save',
        maxLength: 20,
      ),
      () async {
        await tester.tap(_text('Save'));
        await tester.pump();
        expect(find.byType(CcTextInputSheet), findsOneWidget);

        await tester.enterText(find.byType(TextField), '  Anna  ');
        await tester.pump();
        await tester.tap(_text('Save'));
      },
    );
    expect(text, 'Anna');
  });
}
