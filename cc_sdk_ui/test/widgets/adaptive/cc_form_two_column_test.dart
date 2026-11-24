import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _leading = Key('leading');
const _details = Key('details');
const _right = Key('right');

void main() {
  testWidgets('landscape tablet: leading + details left, right in a card', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CcFormTwoColumn(
              leading: [SizedBox(key: _leading, height: 40)],
              details: SizedBox(key: _details, height: 40),
              right: [SizedBox(key: _right, height: 40)],
            ),
          ),
        ),
      ),
    );

    final leading = tester.getRect(find.byKey(_leading));
    final details = tester.getRect(find.byKey(_details));
    final right = tester.getRect(find.byKey(_right));

    expect(details.top, greaterThan(leading.bottom));
    expect(right.left, greaterThan(leading.right));
    expect(right.top, greaterThanOrEqualTo(leading.top));
    expect(find.byType(CcFormCard), findsNWidgets(2));
  });

  testWidgets('shouldUse follows CcTwoColumn', (tester) async {
    late bool phone;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            phone = CcFormTwoColumn.shouldUse(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(phone, isFalse);
  });
}
