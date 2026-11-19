import 'package:cc_sdk_ui/src/widgets/adaptive/cc_content_inset.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const _card = Key('card');

Future<({double outer, double inner})> _pump(
  WidgetTester tester,
  double width,
) async {
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  late double outer;
  late double inner;
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: CcContentInset(
        child: Builder(
          builder: (context) {
            outer = CcContentInset.of(context);
            return Column(
              children: [
                CcContentPadding(
                  child: Builder(
                    builder: (context) {
                      inner = CcContentInset.of(context);
                      return const SizedBox(
                        key: _card,
                        width: double.infinity,
                        height: 10,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
  return (outer: outer, inner: inner);
}

void main() {
  testWidgets('no inset up to the content width (phones, portrait tablets)', (
    tester,
  ) async {
    final insets = await _pump(tester, 800);
    expect(insets.outer, 0);
    expect(tester.getSize(find.byKey(_card)).width, 800);
  });

  testWidgets('wide: inset centres content; padding caps and resets it', (
    tester,
  ) async {
    final insets = await _pump(tester, 1040);
    expect(insets.outer, 100);
    expect(insets.inner, 0, reason: 'already applied by CcContentPadding');
    expect(tester.getSize(find.byKey(_card)).width, 840);
    expect(tester.getTopLeft(find.byKey(_card)).dx, 100);
  });

  testWidgets('no scope means no inset', (tester) async {
    late double inset;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          inset = CcContentInset.of(context);
          return const SizedBox.shrink();
        },
      ),
    );
    expect(inset, 0);
  });
}
