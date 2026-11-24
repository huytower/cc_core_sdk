import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _text(String text) => find.text(text, findRichText: true);

Future<int?> _open(WidgetTester tester, CcPickerSheetFrame Function() frame) {
  return _run(tester, frame);
}

Future<int?> _run(
  WidgetTester tester,
  CcPickerSheetFrame Function() frame, {
  Future<void> Function()? interact,
}) async {
  int? result;
  var closed = false;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            result = await CcAdaptiveBottomSheet.show<int>(
              context: context,
              builder: (_) => frame(),
            );
            closed = true;
          },
          child: const Text('open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  if (interact != null) {
    await interact();
    await tester.pumpAndSettle();
    expect(closed, isTrue);
  }
  return result;
}

void main() {
  testWidgets('title header, body, Cancel / OK from Material', (tester) async {
    await _open(
      tester,
      () => CcPickerSheetFrame(
        title: 'Pick one',
        icon: Icons.star,
        body: const Text('body'),
        onConfirm: () {},
      ),
    );
    expect(_text('Pick one'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('body'), findsOneWidget);
    expect(_text('Cancel'), findsOneWidget);
    expect(_text('OK'), findsOneWidget);
  });

  testWidgets('no onConfirm: no action row', (tester) async {
    await _open(
      tester,
      () => const CcPickerSheetFrame(title: 'Info', body: Text('body')),
    );
    expect(_text('OK'), findsNothing);
    expect(_text('Cancel'), findsNothing);
  });

  testWidgets('OK runs onConfirm, which returns the result', (tester) async {
    late BuildContext sheetContext;
    final result = await _run(
      tester,
      () => CcPickerSheetFrame(
        title: 'Pick',
        body: Builder(
          builder: (context) {
            sheetContext = context;
            return const Text('body');
          },
        ),
        onConfirm: () => Navigator.of(sheetContext).pop(7),
      ),
      interact: () => tester.tap(_text('OK')),
    );
    expect(result, 7);
  });

  testWidgets('Cancel closes with no result; custom labels', (tester) async {
    final result = await _run(
      tester,
      () => CcPickerSheetFrame(
        title: 'Pick',
        body: const Text('body'),
        confirmLabel: 'Save',
        cancelLabel: 'Back',
        onConfirm: () {},
      ),
      interact: () => tester.tap(_text('Back')),
    );
    expect(result, isNull);
  });

  testWidgets('scrollable body: long content scrolls, OK stays in view', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _open(
      tester,
      () => CcPickerSheetFrame(
        title: 'Guide',
        hasScrollableBody: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              for (var i = 0; i < 40; i++)
                SizedBox(height: 40, child: Text('row $i')),
            ],
          ),
        ),
        hasCancel: false,
        onConfirm: () {},
      ),
    );
    expect(tester.takeException(), isNull);
    final ok = tester.getRect(_text('OK'));
    expect(ok.bottom, lessThanOrEqualTo(600));
    expect(find.text('row 39').hitTestable(), findsNothing);
  });

  testWidgets('single button when hasCancel is false; custom header', (
    tester,
  ) async {
    await _open(
      tester,
      () => CcPickerSheetFrame(
        header: const Text('my header'),
        body: const Text('body'),
        hasCancel: false,
        confirmLabel: 'Got it',
        onConfirm: () {},
      ),
    );
    expect(find.text('my header'), findsOneWidget);
    expect(_text('Got it'), findsOneWidget);
    expect(_text('Cancel'), findsNothing);
    expect(find.byType(CcSheetHeader), findsNothing);
  });
}
