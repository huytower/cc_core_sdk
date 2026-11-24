import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _content = Key('content');

Future<void> _openSheet(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => CcAdaptiveBottomSheet.show<void>(
            context: context,
            builder: (_) =>
                const SizedBox(key: _content, height: 100, width: 2000),
          ),
          child: const Text('open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('phone: full width', (tester) async {
    await _openSheet(tester, const Size(400, 800));
    expect(tester.getSize(find.byKey(_content)).width, 400);
  });

  testWidgets('tablet: narrowed to 480 dp and centred', (tester) async {
    await _openSheet(tester, const Size(1000, 800));
    final rect = tester.getRect(find.byKey(_content));
    expect(rect.width, CcAdaptiveBottomSheet.defaultTabletMaxWidth);
    expect(rect.center.dx, 500);
  });

  testWidgets('constraintsFor: none on phones, capped on tablets', (
    tester,
  ) async {
    late BoxConstraints? phone;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            phone = CcAdaptiveBottomSheet.constraintsFor(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(phone, isNull);

    late BoxConstraints? tablet;
    tester.view.physicalSize = const Size(1000, 800);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            tablet = CcAdaptiveBottomSheet.constraintsFor(
              context,
              tabletMaxWidth: 600,
            );
            return const SizedBox();
          },
        ),
      ),
    );
    expect(tablet?.maxWidth, 600);
  });
}
