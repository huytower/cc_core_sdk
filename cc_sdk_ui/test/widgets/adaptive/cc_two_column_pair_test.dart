import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _first = Key('first');
const _second = Key('second');

Future<void> _pump(
  WidgetTester tester,
  Size size,
  List<Widget> children,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: SingleChildScrollView(
        child: CcTwoColumnPair(gap: 20, children: children),
      ),
    ),
  );
}

void main() {
  testWidgets('landscape tablet: side by side, half each', (tester) async {
    await _pump(tester, const Size(1000, 700), const [
      SizedBox(key: _first, height: 50),
      SizedBox(key: _second, height: 50),
    ]);
    final first = tester.getRect(find.byKey(_first));
    final second = tester.getRect(find.byKey(_second));

    expect(first.top, second.top);
    expect(first.width, closeTo(490, 0.01));
    expect(second.width, closeTo(490, 0.01));
    expect(second.left, closeTo(first.right + 20, 0.01));
  });

  testWidgets('landscape tablet: a lone card keeps its half', (tester) async {
    await _pump(tester, const Size(1000, 700), const [
      SizedBox(key: _first, height: 50),
    ]);
    expect(tester.getRect(find.byKey(_first)).width, closeTo(490, 0.01));
  });

  testWidgets('phone: stacked with the gap between', (tester) async {
    await _pump(tester, const Size(400, 800), const [
      SizedBox(key: _first, height: 50),
      SizedBox(key: _second, height: 50),
    ]);
    final first = tester.getRect(find.byKey(_first));
    final second = tester.getRect(find.byKey(_second));

    expect(first.left, second.left);
    expect(second.top, closeTo(first.bottom + 20, 0.01));
  });

  testWidgets('no children: nothing', (tester) async {
    await _pump(tester, const Size(400, 800), const []);
    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsNothing);
  });
}
