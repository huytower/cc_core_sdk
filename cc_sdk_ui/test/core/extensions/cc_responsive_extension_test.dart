import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps a window [width] dp wide and returns a context inside it.
Future<BuildContext> _contextAt(WidgetTester tester, double width) async {
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  late BuildContext context;
  await tester.pumpWidget(
    Builder(
      builder: (ctx) {
        context = ctx;
        return const SizedBox.shrink();
      },
    ),
  );
  return context;
}

void main() {
  testWidgets('a 360 dp phone is the base scale', (tester) async {
    final context = await _contextAt(tester, 360);

    expect(context.respDim(10), 10);
    expect(context.respPadding(8), 8);
    expect(context.respIconSize(), 24);
  });

  testWidgets('sizes stop growing at the expanded width', (tester) async {
    final atExpanded = await _contextAt(tester, CcScale.expandedWidth);
    final expandedDim = atExpanded.respDim(10);
    final expandedPadding = atExpanded.respPadding(10);

    final wide = await _contextAt(tester, 1600);

    expect(expandedDim, 10 * CcScale.maxDimension);
    expect(expandedPadding, 10 * CcScale.maxPadding);
    expect(wide.respDim(10), expandedDim);
    expect(wide.respPadding(10), expandedPadding);
  });

  testWidgets('a compact window sizes headers by screen height', (
    tester,
  ) async {
    final context = await _contextAt(tester, 360);

    expect(context.respHeaderHeight(0.25), 800 * 0.25);
  });
}
