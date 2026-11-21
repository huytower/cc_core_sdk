import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/main.dart';

// Keeps example/main.dart compiling and working: it uses only cc_sdk_data,
// so this also proves the package stands alone.
void main() {
  testWidgets('shows the first page of users', (tester) async {
    await tester.pumpWidget(const CcSdkDataExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('Page 1'), findsOneWidget);
    expect(find.text('user0@example.com'), findsOneWidget);
    // An odd user has no email, so it is shown by phone number.
    expect(find.text('+10000001'), findsOneWidget);
  });

  testWidgets('pages forward and back', (tester) async {
    await tester.pumpWidget(const CcSdkDataExampleApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Page 2'), findsOneWidget);
    expect(find.text('user10@example.com'), findsOneWidget);

    await tester.tap(find.text('Previous'));
    await tester.pumpAndSettle();
    expect(find.text('Page 1'), findsOneWidget);
  });

  testWidgets('shows the failure message', (tester) async {
    await tester.pumpWidget(
      const CcSdkDataExampleApp(source: ExampleUserSource(failOnPage: 1)),
    );
    await tester.pumpAndSettle();

    expect(find.text('No connection'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });
}
