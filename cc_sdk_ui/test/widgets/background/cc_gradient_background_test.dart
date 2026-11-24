import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('page: body fills the space over an even tint', (tester) async {
    const body = Key('body');
    const tint = Color(0xFF3366FF);
    await tester.pumpWidget(
      const MaterialApp(
        home: CcGradientBackground.page(
          tint: tint,
          child: SizedBox(key: body),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(body)),
      tester.view.physicalSize / tester.view.devicePixelRatio,
    );

    final box = tester.widget<Container>(
      find.descendant(
        of: find.byType(Positioned),
        matching: find.byType(Container),
      ),
    );
    final gradient =
        (box.decoration! as BoxDecoration).gradient! as LinearGradient;
    final expected = tint.withAlpha(CcGradientBackground.defaultPageTintAlpha);
    expect(gradient.colors, [expected, expected]);
  });
}
