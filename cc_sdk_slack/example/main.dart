// Minimal example of cc_sdk_slack: user feedback sent to a Slack incoming
// webhook through the CcFeedbackReporter interface from cc_sdk.
//
// Run with your own webhook (the SDK never reads --dart-define itself; the app
// does and passes the value in):
//   flutter run example/main.dart --dart-define=SLACK_WEBHOOK_URL=https://hooks.slack.com/...
//
// Crash alerts use the same webhook through Catcher2:
//   Catcher2Options(DialogReportMode(), [
//     CcSlackHandler(webhookUrl: url, attestation: appAttestation),
//   ])
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_slack/export_cc_sdk_slack.dart';
import 'package:flutter/material.dart';

void main() {
  const webhookUrl = String.fromEnvironment('SLACK_WEBHOOK_URL');
  runApp(
    CcSdkSlackExampleApp(
      reporter: CcSlackFeedbackReporter(webhookUrl: webhookUrl),
    ),
  );
}

class CcSdkSlackExampleApp extends StatelessWidget {
  const CcSdkSlackExampleApp({super.key, required this.reporter});

  /// Any [CcFeedbackReporter]: the Slack one in the app, a fake in tests.
  final CcFeedbackReporter reporter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cc_sdk_slack example',
      home: ExampleFeedbackPage(reporter: reporter),
    );
  }
}

class ExampleFeedbackPage extends StatefulWidget {
  const ExampleFeedbackPage({super.key, required this.reporter});

  final CcFeedbackReporter reporter;

  @override
  State<ExampleFeedbackPage> createState() => _ExampleFeedbackPageState();
}

class _ExampleFeedbackPageState extends State<ExampleFeedbackPage> {
  final _text = TextEditingController();
  double _rating = 4;
  String _result = '';

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final sent = await widget.reporter.send(
      CcFeedback(text: _text.text, rating: _rating, praise: const ['Fast']),
    );
    if (!mounted) return;
    setState(() => _result = sent ? 'Sent' : 'Not sent');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send feedback')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('feedback'),
            controller: _text,
            decoration: const InputDecoration(labelText: 'Feedback'),
          ),
          Slider(
            value: _rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _rating.toStringAsFixed(0),
            onChanged: (value) => setState(() => _rating = value),
          ),
          FilledButton(onPressed: _send, child: const Text('Send')),
          Text(_result),
        ],
      ),
    );
  }
}
