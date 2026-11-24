import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('starts at the rounded average and reports a tap', (
    tester,
  ) async {
    int? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CcRatingPill(
            averageRating: 3.6,
            ratingLabel: (rating) => '$rating / 5',
            onRatingSelected: (rating) => selected = rating,
          ),
        ),
      ),
    );

    expect(find.text('4 / 5', findRichText: true), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));

    await tester.tap(find.byIcon(Icons.star_border_rounded));
    await tester.pump(const Duration(seconds: 1));

    expect(selected, 5);
    expect(find.text('5 / 5', findRichText: true), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));
  });
}
