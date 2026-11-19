import 'package:cc_sdk_ui/src/widgets/adaptive/cc_multi_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _box(String key, double height) =>
    SizedBox(key: Key(key), height: height);

Future<void> _pump(WidgetTester tester, List<Widget> children, {int? cols}) {
  tester.view.physicalSize = const Size(1000, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  return tester.pumpWidget(
    MaterialApp(
      home: SingleChildScrollView(
        child: CcMultiColumn(
          columns: cols ?? 3,
          columnGap: 10,
          rowGap: 4,
          children: children,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('flows left to right, then top to bottom', (tester) async {
    await _pump(tester, [
      _box('a', 30),
      _box('b', 50),
      _box('c', 20),
      _box('d', 10),
      _box('e', 10),
    ]);
    final a = tester.getRect(find.byKey(const Key('a')));
    final b = tester.getRect(find.byKey(const Key('b')));
    final c = tester.getRect(find.byKey(const Key('c')));
    final d = tester.getRect(find.byKey(const Key('d')));
    final e = tester.getRect(find.byKey(const Key('e')));

    // 1000 dp, 2 gaps of 10 -> 3 columns of 326.67.
    expect(a.width, closeTo(326.67, 0.01));
    expect(a.left, 0);
    expect(b.left, closeTo(a.right + 10, 0.01));
    expect(c.left, closeTo(b.right + 10, 0.01));
    expect(a.top, b.top);

    // d goes under a (not under the tallest column), e under b.
    expect(d.left, a.left);
    expect(d.top, a.bottom + 4);
    expect(e.left, b.left);
    expect(e.top, b.bottom + 4);
  });

  testWidgets('a lone item keeps its column width', (tester) async {
    await _pump(tester, [_box('a', 30)]);
    expect(
      tester.getSize(find.byKey(const Key('a'))).width,
      closeTo(326.67, 0.01),
    );
  });

  testWidgets('honours the column count', (tester) async {
    await _pump(tester, [_box('a', 10), _box('b', 10)], cols: 2);
    expect(tester.getSize(find.byKey(const Key('a'))).width, 495);
  });
}
