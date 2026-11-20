import 'package:cc_sdk_ui/src/widgets/adaptive/cc_adaptive_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _label(String text) => Text(text, textDirection: TextDirection.ltr);

Future<void> _pumpInWidth(
  WidgetTester tester,
  double width,
  Widget child,
) async {
  tester.view.physicalSize = const Size(2000, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

void main() {
  final builder = CcAdaptiveBuilder(
    compact: (_) => _label('compact'),
    medium: (_) => _label('medium'),
    expanded: (_) => _label('expanded'),
    large: (_) => _label('large'),
    extraLarge: (_) => _label('extraLarge'),
  );

  final widths = {
    400.0: 'compact',
    700.0: 'medium',
    900.0: 'expanded',
    1300.0: 'large',
    1700.0: 'extraLarge',
  };
  widths.forEach((width, expected) {
    testWidgets('builds the $expected layout at $width dp', (tester) async {
      await _pumpInWidth(tester, width, builder);
      expect(find.text(expected), findsOneWidget);
    });
  });

  testWidgets('measures the space it is given, not the window', (tester) async {
    // Window is 2000 dp wide (extraLarge) but the pane is only 500 dp.
    await _pumpInWidth(tester, 500, builder);
    expect(find.text('compact'), findsOneWidget);
  });

  testWidgets('missing classes fall back to the nearest narrower builder', (
    tester,
  ) async {
    final sparse = CcAdaptiveBuilder(
      compact: (_) => _label('compact'),
      expanded: (_) => _label('expanded'),
    );

    await _pumpInWidth(tester, 700, sparse);
    expect(find.text('compact'), findsOneWidget);

    await _pumpInWidth(tester, 1700, sparse);
    expect(find.text('expanded'), findsOneWidget);
  });

  testWidgets('falls back to the window width when unbounded', (tester) async {
    tester.view.physicalSize = const Size(900, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: builder,
        ),
      ),
    );
    expect(find.text('expanded'), findsOneWidget);
  });
}
