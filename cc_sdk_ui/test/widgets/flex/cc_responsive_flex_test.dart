import 'package:cc_sdk_ui/widgets/flex/cc_responsive_flex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpInWidth(WidgetTester tester, double width) async {
  tester.view.physicalSize = const Size(2000, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          child: const CcResponsiveFlex(
            children: [Text('a'), Text('b'), Text('c'), Text('d')],
          ),
        ),
      ),
    ),
  );
}

void main() {
  final cases = {400.0: 0, 700.0: 2, 1000.0: 2};
  // width -> expected Row count (compact stacks in a single Column).
  cases.forEach((width, rows) {
    testWidgets('$width dp lays out $rows row(s)', (tester) async {
      await _pumpInWidth(tester, width);
      expect(find.byType(Row), findsNWidgets(rows));
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('follows its own width, not the window', (tester) async {
    // Window is 2000 dp wide, but the widget only gets 500 dp: compact.
    await _pumpInWidth(tester, 500);
    expect(find.byType(Row), findsNothing);
  });
}
