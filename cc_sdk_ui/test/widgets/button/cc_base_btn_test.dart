import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Widget child) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

Future<void> _tapAndSettle(WidgetTester tester, String title) async {
  await tester.tap(find.text(title, findRichText: true));
  await tester.pumpAndSettle();
  // Let the debounce timer run out.
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  testWidgets('CcBaseBtn calls onTap once per tap', (tester) async {
    var taps = 0;
    await _pump(tester, CcBaseBtn(title: 'Save', onTap: () => taps++));

    await _tapAndSettle(tester, 'Save');

    expect(taps, 1);
  });

  testWidgets('a disabled CcBaseBtn ignores taps', (tester) async {
    var taps = 0;
    await _pump(
      tester,
      CcBaseBtn(title: 'Save', isEnable: false, onTap: () => taps++),
    );

    await _tapAndSettle(tester, 'Save');

    expect(taps, 0);
  });

  testWidgets('debounce drops a second tap that comes too soon', (
    tester,
  ) async {
    var taps = 0;
    await _pump(tester, CcBaseBtn(title: 'Save', onTap: () => taps++));

    await tester.tap(find.text('Save', findRichText: true));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Save', findRichText: true));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(taps, 1);
  });

  testWidgets('CcBadgeCounter shows the count', (tester) async {
    await _pump(tester, const CcBadgeCounter(count: 7));

    expect(find.text('7', findRichText: true), findsOneWidget);
  });
}
