import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _text(String text) => find.text(text, findRichText: true);

Future<void> _pump(
  WidgetTester tester,
  String cancel,
  String confirm, {
  VoidCallback? onCancel,
}) {
  tester.view.physicalSize = const Size(320, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CcPickerSheetFrame(
          title: 'Title',
          body: const SizedBox(height: 40),
          cancelLabel: cancel,
          confirmLabel: confirm,
          onConfirm: () {},
          onCancel: onCancel,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('short labels sit side by side, confirm last', (tester) async {
    await _pump(tester, 'No', 'Yes');

    final cancel = tester.getCenter(_text('No'));
    final confirm = tester.getCenter(_text('Yes'));
    expect(confirm.dy, cancel.dy);
    expect(confirm.dx, greaterThan(cancel.dx));
  });

  testWidgets('onCancel takes over the first button', (tester) async {
    var cancels = 0;
    await _pump(tester, 'No', 'Yes', onCancel: () => cancels++);

    await tester.tap(_text('No'));
    await tester.pumpAndSettle();
    expect(cancels, 1);
    // The sheet stays: closing it is now up to the caller.
    expect(find.byType(CcPickerSheetFrame), findsOneWidget);
  });

  testWidgets('long labels stack instead of overflowing', (tester) async {
    await _pump(tester, 'Keep everything', 'Show the history');

    expect(tester.takeException(), isNull);
    expect(
      tester.getCenter(_text('Show the history')).dy,
      greaterThan(tester.getCenter(_text('Keep everything')).dy),
    );
  });
}
