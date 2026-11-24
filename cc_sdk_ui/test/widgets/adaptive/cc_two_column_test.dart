import 'package:cc_sdk_ui/src/widgets/adaptive/cc_two_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _left = Key('left');
const _right = Key('right');

Future<void> _pump(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    const MaterialApp(
      home: SingleChildScrollView(
        child: CcTwoColumn(
          gap: 20,
          left: [SizedBox(key: _left, height: 50)],
          right: [SizedBox(key: _right, height: 50)],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('splits 3 : 2 side by side, capped and centred', (tester) async {
    await _pump(tester, const Size(1600, 800));
    final left = tester.getRect(find.byKey(_left));
    final right = tester.getRect(find.byKey(_right));

    // 1200 dp block centred in 1600 dp, 20 dp gap: (1200 - 20) split 3 : 2.
    expect(left.left, 200);
    expect(left.width, closeTo(708, 0.01));
    expect(right.width, closeTo(472, 0.01));
    expect(right.left, closeTo(left.right + 20, 0.01));
    expect(right.right, 1400);
    expect(left.top, right.top);
  });

  testWidgets('narrower than the cap: uses the whole width', (tester) async {
    await _pump(tester, const Size(1000, 700));
    expect(tester.getRect(find.byKey(_left)).left, 0);
    expect(tester.getRect(find.byKey(_right)).right, 1000);
  });

  group('shouldUse', () {
    Future<bool> use(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      late bool result;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            result = CcTwoColumn.shouldUse(context);
            return const SizedBox.shrink();
          },
        ),
      );
      return result;
    }

    testWidgets('landscape tablets: yes', (tester) async {
      expect(await use(tester, const Size(960, 600)), isTrue);
      expect(await use(tester, const Size(1280, 800)), isTrue);
    });

    testWidgets('portrait (phones, tablets) and tiny windows: no', (
      tester,
    ) async {
      expect(await use(tester, const Size(390, 844)), isFalse);
      expect(await use(tester, const Size(800, 1280)), isFalse);
      expect(await use(tester, const Size(560, 360)), isFalse);
    });

    testWidgets('phone held sideways: no, even though it is wide', (
      tester,
    ) async {
      expect(await use(tester, const Size(844, 390)), isFalse);
      expect(await use(tester, const Size(932, 430)), isFalse);
    });

    testWidgets('unfolded foldable and iPad mini sideways: yes', (
      tester,
    ) async {
      expect(await use(tester, const Size(841, 673)), isTrue);
      expect(await use(tester, const Size(1133, 744)), isTrue);
    });
  });
}
