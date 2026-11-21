import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CcWindowSizeClass.fromWidth', () {
    final cases = {
      0.0: CcWindowSizeClass.compact,
      359.0: CcWindowSizeClass.compact,
      599.9: CcWindowSizeClass.compact,
      600.0: CcWindowSizeClass.medium,
      800.0: CcWindowSizeClass.medium,
      839.9: CcWindowSizeClass.medium,
      840.0: CcWindowSizeClass.expanded,
      1199.9: CcWindowSizeClass.expanded,
      1200.0: CcWindowSizeClass.large,
      1599.9: CcWindowSizeClass.large,
      1600.0: CcWindowSizeClass.extraLarge,
      double.infinity: CcWindowSizeClass.extraLarge,
    };
    cases.forEach((width, expected) {
      test('$width dp -> ${expected.name}', () {
        expect(CcWindowSizeClass.fromWidth(width), expected);
      });
    });

    test('fromConstraints uses the max width', () {
      expect(
        CcWindowSizeClass.fromConstraints(
          const BoxConstraints(minWidth: 100, maxWidth: 700),
        ),
        CcWindowSizeClass.medium,
      );
    });
  });

  group('CcWindowSizeClass comparisons', () {
    test('isAtLeast / isBelow follow width order', () {
      expect(
        CcWindowSizeClass.expanded.isAtLeast(CcWindowSizeClass.medium),
        isTrue,
      );
      expect(
        CcWindowSizeClass.medium.isAtLeast(CcWindowSizeClass.medium),
        isTrue,
      );
      expect(
        CcWindowSizeClass.compact.isAtLeast(CcWindowSizeClass.medium),
        isFalse,
      );
      expect(
        CcWindowSizeClass.compact.isBelow(CcWindowSizeClass.medium),
        isTrue,
      );
      expect(CcWindowSizeClass.large.isBelow(CcWindowSizeClass.large), isFalse);
    });
  });

  group('CcWindowSizeClass.select', () {
    test('returns the exact value when provided', () {
      expect(
        CcWindowSizeClass.expanded.select(
          compact: 1,
          medium: 2,
          expanded: 3,
          large: 4,
          extraLarge: 5,
        ),
        3,
      );
    });

    test('falls back to the nearest narrower value', () {
      int pick(CcWindowSizeClass c) => c.select(compact: 1, expanded: 3);

      expect(pick(CcWindowSizeClass.compact), 1);
      expect(pick(CcWindowSizeClass.medium), 1);
      expect(pick(CcWindowSizeClass.expanded), 3);
      expect(pick(CcWindowSizeClass.large), 3);
      expect(pick(CcWindowSizeClass.extraLarge), 3);
    });
  });

  group('CcWindowHeightClass.fromHeight', () {
    final cases = {
      360.0: CcWindowHeightClass.compact,
      479.9: CcWindowHeightClass.compact,
      480.0: CcWindowHeightClass.medium,
      800.0: CcWindowHeightClass.medium,
      899.9: CcWindowHeightClass.medium,
      900.0: CcWindowHeightClass.expanded,
      double.infinity: CcWindowHeightClass.expanded,
    };
    cases.forEach((height, expected) {
      test('$height dp -> ${expected.name}', () {
        expect(CcWindowHeightClass.fromHeight(height), expected);
      });
    });
  });

  testWidgets('of(context) reads the window size', (tester) async {
    tester.view.physicalSize = const Size(1600, 2560);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    late CcWindowSizeClass width;
    late CcWindowHeightClass height;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          width = CcWindowSizeClass.of(context);
          height = CcWindowHeightClass.of(context);
          return const SizedBox.shrink();
        },
      ),
    );

    // 800 x 1280 dp: a 10" tablet in portrait.
    expect(width, CcWindowSizeClass.medium);
    expect(height, CcWindowHeightClass.expanded);
  });
}
