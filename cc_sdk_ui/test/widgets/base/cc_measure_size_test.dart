import 'package:cc_sdk_ui/widgets/base/cc_measure_size.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('reports the first size and only real changes', (tester) async {
    final sizes = <Size>[];
    Widget box(double height) => Align(
      alignment: Alignment.topLeft,
      child: CcMeasureSize(
        onChange: sizes.add,
        child: SizedBox(width: 100, height: height),
      ),
    );

    await tester.pumpWidget(box(40));
    await tester.pump();
    expect(sizes, [const Size(100, 40)]);

    await tester.pumpWidget(box(40));
    await tester.pump();
    expect(sizes, hasLength(1));

    await tester.pumpWidget(box(64));
    await tester.pump();
    expect(sizes.last, const Size(100, 64));
    expect(sizes, hasLength(2));
  });
}
