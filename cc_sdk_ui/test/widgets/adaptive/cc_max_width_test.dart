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
}
