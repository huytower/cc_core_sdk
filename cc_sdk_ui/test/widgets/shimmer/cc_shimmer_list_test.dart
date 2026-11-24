import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the requested number of tiles, two shimmers each', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CcShimmerList(itemCount: 3, itemWidth: 60)),
      ),
    );
    expect(find.byType(CcShimmer), findsNWidgets(6));
  });

  testWidgets('uses the given height', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CcShimmerList(height: 120))),
    );
    final listBox = find.ancestor(
      of: find.byType(ListView),
      matching: find.byType(SizedBox),
    );
    expect(tester.getSize(listBox.first).height, 120);
  });
}
