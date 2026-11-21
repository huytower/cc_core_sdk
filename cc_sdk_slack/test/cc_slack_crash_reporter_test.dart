import 'package:cc_sdk_slack/export_cc_sdk_slack.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats a caught error with its reason and app frame', () {
    final stack = StackTrace.fromString(
      '#0      LiabilityRepositoryImpl.getLiability '
      '(package:app/liability_repository_impl.dart:47:9)\n'
      '#1      _rootRun (dart:async/zone.dart:1525:13)',
    );

    final message = CcSlackCrashReporter.format(
      StateError('Liability 1 not found\nmore detail'),
      stack,
      reason: 'LiabilityRepositoryImpl.safeRequest',
      fatal: false,
      device: 'n/a',
      appCheck: 'Verified',
      time: DateTime(2026, 11, 21, 16, 32),
    );

    expect(message, startsWith('*⚠️ Error reported*'));
    expect(message, contains('`Bad state: Liability 1 not found`'));
    expect(message, isNot(contains('more detail')));
    expect(
      message,
      contains(
        '`package:app/liability_repository_impl.dart:47:9 '
        '[LiabilityRepositoryImpl.getLiability]`',
      ),
    );
    expect(message, contains('*reason*: `LiabilityRepositoryImpl.safeRequest`'));
    expect(message, contains('2026-11-21 16:32 PM'));
  });

  test('marks fatal errors', () {
    final message = CcSlackCrashReporter.format(
      Exception('boom'),
      null,
      reason: 'Caught by Catcher2',
      fatal: true,
      device: 'n/a',
      appCheck: 'n/a',
      time: DateTime(2026),
    );

    expect(message, startsWith('*🚨 Fatal error*'));
    expect(message, contains('*where*: `Unknown location`'));
  });

  test('sends nothing without a webhook URL and never throws', () async {
    final reporter = CcSlackCrashReporter(webhookUrl: '');

    await expectLater(
      reporter.recordError(Exception('x'), null, reason: 'test'),
      completes,
    );
  });
}
