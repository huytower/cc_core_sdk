import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<bool> _twoColumnOn(WidgetTester tester, CcReferenceWindow window) async {
  tester.view.physicalSize = window.size;
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

void main() {
  test('window classes of the reference sizes', () {
    CcWindowSizeClass classOf(CcReferenceWindow window) =>
        CcWindowSizeClass.fromWidth(window.size.width);

    expect(classOf(CcReferenceWindows.phone), CcWindowSizeClass.compact);
    expect(classOf(CcReferenceWindows.tablet7), CcWindowSizeClass.medium);
    expect(classOf(CcReferenceWindows.iPadMini), CcWindowSizeClass.medium);
    // 10–11" tablets held upright are still medium.
    expect(classOf(CcReferenceWindows.tablet10), CcWindowSizeClass.medium);
    expect(classOf(CcReferenceWindows.iPad11), CcWindowSizeClass.medium);
    expect(classOf(CcReferenceWindows.iPad13), CcWindowSizeClass.expanded);
    expect(
      classOf(CcReferenceWindows.tablet10.landscape),
      CcWindowSizeClass.large,
    );
  });

  testWidgets('two columns: every sideways tablet, no phone', (tester) async {
    for (final window in CcReferenceWindows.landscape) {
      final expected = window.size.shortestSide >= 600;
      expect(await _twoColumnOn(tester, window), expected, reason: '$window');
    }
    for (final window in CcReferenceWindows.portrait) {
      expect(await _twoColumnOn(tester, window), isFalse, reason: '$window');
    }
  });

  test('landscape swaps width and height', () {
    final rotated = CcReferenceWindows.iPadMini.landscape;
    expect(rotated.size, const Size(1133, 744));
    expect(rotated.name, 'iPad mini landscape');
  });
}
