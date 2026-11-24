import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Widget page) =>
    tester.pumpWidget(MaterialApp(home: Scaffold(body: page)));

Finder _richText(String text) => find.text(text, findRichText: true);

void main() {
  testWidgets('CcLoadingPage shows an activity indicator', (tester) async {
    await _pump(tester, const CcLoadingPage());

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
  });

  testWidgets('CcEmptyPage has a default message and takes a custom one', (
    tester,
  ) async {
    await _pump(tester, const CcEmptyPage());
    expect(_richText('No data found'), findsOneWidget);

    await _pump(tester, const CcEmptyPage(message: 'Nothing yet'));
    expect(_richText('Nothing yet'), findsOneWidget);
  });

  testWidgets('CcErrorPage shows the message and calls onRetry', (tester) async {
    var retries = 0;
    await _pump(
      tester,
      CcErrorPage(
        message: 'Server down',
        retryText: 'Try again',
        onRetry: () => retries++,
      ),
    );

    expect(_richText('Server down'), findsOneWidget);
    await tester.tap(_richText('Try again'));
    await tester.pumpAndSettle();
    // Let the button's debounce timer run out.
    await tester.pump(const Duration(seconds: 1));

    expect(retries, 1);
  });

  testWidgets('CcErrorPage hides the retry button without onRetry', (
    tester,
  ) async {
    await _pump(tester, const CcErrorPage(message: 'Server down'));

    expect(_richText('Retry'), findsNothing);
  });

  testWidgets('CcSectionEmptyState shows its message', (tester) async {
    await _pump(tester, const CcSectionEmptyState(message: 'No items'));

    expect(_richText('No items'), findsOneWidget);
  });
}
