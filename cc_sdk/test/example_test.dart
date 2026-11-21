import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/main.dart';

class _RecordingAnalytics extends CcNoopAnalytics {
  final screens = <String>[];

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async => screens.add(screenName);
}

// Keeps example/main.dart compiling and working: it uses only cc_sdk and no
// vendor package, so this also proves the core ring stands alone.
void main() {
  setUp(() => CcSdkConfig.configure(const CcSdkConfig(appName: 'Example')));
  tearDown(() => CcSdkConfig.configure(const CcSdkConfig()));

  testWidgets('shows the configured name and a formatted number', (
    tester,
  ) async {
    await tester.pumpWidget(const CcSdkExampleApp());

    expect(find.text('Example'), findsOneWidget);
    expect(find.text('Compact number: 1.5 million'), findsOneWidget);
  });

  testWidgets('validates a phone number with the injected validator', (
    tester,
  ) async {
    await tester.pumpWidget(const CcSdkExampleApp());

    await tester.enterText(find.byKey(const Key('phone')), '+84 912-345-678');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.text('+84912345678'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('phone')), '0912');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.text('Invalid number'), findsOneWidget);
  });

  testWidgets('logs the screen view through the injected analytics', (
    tester,
  ) async {
    final analytics = _RecordingAnalytics();

    await tester.pumpWidget(CcSdkExampleApp(analytics: analytics));

    expect(analytics.screens, ['example_home']);
  });
}
