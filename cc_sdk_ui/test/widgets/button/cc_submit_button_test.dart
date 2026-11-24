import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  required bool hasEnabled,
  required bool hasSubmitting,
  required VoidCallback onTap,
  Widget? badge,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CcSubmitButton(
          text: 'Save',
          hasEnabled: hasEnabled,
          hasSubmitting: hasSubmitting,
          onTap: onTap,
          activeColor: Colors.green,
          badge: badge,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('enabled: taps go through', (tester) async {
    var taps = 0;
    await _pump(
      tester,
      hasEnabled: true,
      hasSubmitting: false,
      onTap: () => taps++,
    );
    await tester.tap(find.text('Save'));
    expect(taps, 1);
  });

  testWidgets('disabled: no tap', (tester) async {
    var taps = 0;
    await _pump(
      tester,
      hasEnabled: false,
      hasSubmitting: false,
      onTap: () => taps++,
    );
    await tester.tap(find.text('Save'));
    expect(taps, 0);
  });

  testWidgets('submitting: spinner instead of the label', (tester) async {
    await _pump(tester, hasEnabled: true, hasSubmitting: true, onTap: () {});
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsNothing);
  });

  testWidgets('shows the badge', (tester) async {
    await _pump(
      tester,
      hasEnabled: true,
      hasSubmitting: false,
      onTap: () {},
      badge: const Text('3'),
    );
    expect(find.text('3'), findsOneWidget);
  });
}
