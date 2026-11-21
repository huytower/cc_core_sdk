import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_slack/export_cc_sdk_slack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/main.dart';

class _RecordingReporter implements CcFeedbackReporter {
  _RecordingReporter({this.result = true});

  final bool result;
  final sent = <CcFeedback>[];

  @override
  Future<bool> send(
    CcFeedback feedback, {
    CcFeedbackLabels labels = CcFeedbackLabels.english,
  }) async {
    sent.add(feedback);
    return result;
  }
}

// Keeps example/main.dart compiling and working.
void main() {
  testWidgets('sends the typed feedback with its rating', (tester) async {
    final reporter = _RecordingReporter();
    await tester.pumpWidget(CcSdkSlackExampleApp(reporter: reporter));

    await tester.enterText(find.byKey(const Key('feedback')), 'Love it');
    await tester.tap(find.text('Send'));
    await tester.pump();

    expect(reporter.sent.single.text, 'Love it');
    expect(reporter.sent.single.rating, 4);
    expect(find.text('Sent'), findsOneWidget);
  });

  testWidgets('shows when the feedback was not sent', (tester) async {
    await tester.pumpWidget(
      CcSdkSlackExampleApp(reporter: _RecordingReporter(result: false)),
    );

    await tester.tap(find.text('Send'));
    await tester.pump();

    expect(find.text('Not sent'), findsOneWidget);
  });

  testWidgets('without a webhook URL the Slack reporter sends nothing', (
    tester,
  ) async {
    await tester.pumpWidget(
      CcSdkSlackExampleApp(
        reporter: CcSlackFeedbackReporter(webhookUrl: ''),
      ),
    );

    await tester.tap(find.text('Send'));
    await tester.pump();

    expect(find.text('Not sent'), findsOneWidget);
  });
}
