import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const double _itemWidth = 100;
const double _gap = 10;

Future<ScrollController> _pumpRow(WidgetTester tester, {GlobalKey? key}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final controller = ScrollController();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 80,
          child: ListView.separated(
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: 30,
            separatorBuilder: (_, _) => const SizedBox(width: _gap),
            itemBuilder: (_, index) =>
                SizedBox(key: index == 20 ? key : null, width: _itemWidth),
          ),
        ),
      ),
    ),
  );
  return controller;
}

void main() {
  testWidgets('scrolls toward an off-screen item', (tester) async {
    final controller = await _pumpRow(tester);

    CcScrollReveal.reveal(
      scrollController: controller,
      index: 20,
      itemWidth: _itemWidth,
      itemGap: _gap,
      leadingPadding: 0,
    );
    await tester.pumpAndSettle();

    expect(controller.offset, greaterThan(0));
  });

  testWidgets('negative index: does nothing', (tester) async {
    final controller = await _pumpRow(tester);

    CcScrollReveal.reveal(
      scrollController: controller,
      index: -1,
      itemWidth: _itemWidth,
      itemGap: _gap,
      leadingPadding: 0,
    );
    await tester.pumpAndSettle();

    expect(controller.offset, 0);
  });

  testWidgets('with an item key: ends with the item centred', (tester) async {
    final key = GlobalKey();
    final controller = await _pumpRow(tester, key: key);

    CcScrollReveal.reveal(
      scrollController: controller,
      index: 20,
      itemWidth: _itemWidth,
      itemGap: _gap,
      leadingPadding: 0,
      itemKey: key,
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    final rect = tester.getRect(find.byKey(key));
    expect(rect.center.dx, closeTo(180, 1));
  });
}
