import 'package:cc_sdk_ui/widgets/adaptive/cc_max_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _child = Key('child');

Future<void> _pump(WidgetTester tester, double windowWidth) async {
  tester.view.physicalSize = Size(windowWidth, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const Directionality(
      textDirection: TextDirection.ltr,
      child: CcMaxWidth(maxWidth: 840, child: SizedBox.expand(key: _child)),
    ),
  );
}

void main() {
  testWidgets('passes narrower space through untouched', (tester) async {
    await _pump(tester, 600);
    expect(tester.getSize(find.byKey(_child)), const Size(600, 900));
  });

  testWidgets('caps the width, centres, and keeps the full height', (
    tester,
  ) async {
    await _pump(tester, 1200);
    expect(tester.getSize(find.byKey(_child)), const Size(840, 900));
    expect(tester.getTopLeft(find.byKey(_child)).dx, 180);
  });

  test('insetFor centres content-width content, 0 when there is no room', () {
    expect(CcMaxWidth.insetFor(600), 0);
    expect(CcMaxWidth.insetFor(840), 0);
    expect(CcMaxWidth.insetFor(1040), 100);
    expect(CcMaxWidth.insetFor(1000, maxWidth: 600), 200);
  });

  testWidgets('CcMaxWidth.content caps at the content width', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: CcMaxWidth.content(child: SizedBox.expand(key: _child)),
      ),
    );
    expect(tester.getSize(find.byKey(_child)).width, CcMaxWidth.contentWidth);
  });
}
