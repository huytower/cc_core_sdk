import 'package:cc_sdk_ui/src/widgets/scroll/cc_landscape_scrollable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    const Directionality(
      textDirection: TextDirection.ltr,
      child: CcLandscapeScrollable(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [SizedBox(height: 900, width: 100)],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('portrait: content is left as it is', (tester) async {
    await _pump(tester, const Size(800, 1280));
    expect(find.byType(SingleChildScrollView), findsNothing);
  });

  testWidgets('landscape: tall content scrolls instead of overflowing', (
    tester,
  ) async {
    await _pump(tester, const Size(960, 600));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
