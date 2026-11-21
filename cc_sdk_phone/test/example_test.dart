import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/main.dart';

Future<void> _submit(WidgetTester tester, String number) async {
  await tester.enterText(find.byKey(const Key('phone')), number);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
}

// Keeps example/main.dart compiling and working.
void main() {
  testWidgets('formats a valid mobile number, trunk zero dropped', (
    tester,
  ) async {
    await tester.pumpWidget(const CcSdkPhoneExampleApp());

    await _submit(tester, '0912345678');

    expect(find.text('+84912345678'), findsOneWidget);
  });

  testWidgets('rejects a number that is too short', (tester) async {
    await tester.pumpWidget(const CcSdkPhoneExampleApp());

    await _submit(tester, '0912');

    expect(find.text('Not a valid mobile number'), findsOneWidget);
  });
}
