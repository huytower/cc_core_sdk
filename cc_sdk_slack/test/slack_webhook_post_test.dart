import 'dart:convert';
import 'dart:io';

import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_slack/export_cc_sdk_slack.dart';
import 'package:flutter_test/flutter_test.dart';

/// A local stand-in for a Slack incoming webhook: records each posted `text`
/// and answers with [statusCode].
class _FakeSlack {
  late final HttpServer _server;
  final posts = <String>[];
  int statusCode = 200;

  String get url => 'http://${_server.address.host}:${_server.port}/hook';

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server.listen((request) async {
      final body = await utf8.decoder.bind(request).join();
      posts.add((jsonDecode(body) as Map<String, dynamic>)['text'] as String);
      request.response
        ..statusCode = statusCode
        ..write(statusCode == 200 ? 'ok' : 'invalid_token');
      await request.response.close();
    });
  }

  Future<void> stop() => _server.close(force: true);
}

class _FakeAttestation extends CcNoopAppAttestation {
  const _FakeAttestation();

  @override
  Future<String> statusDescription() async => 'Verified';
}

Report _report(String error) => Report(
  StateError(error),
  StackTrace.fromString(
    '#0      CartPage.build (package:shop/cart_page.dart:10:5)\n'
    '#1      StatelessElement.build (package:flutter/widgets.dart:1:1)',
  ),
  DateTime(2026, 1, 2, 15, 4),
  {'brand': 'Pixel', 'model': '8', 'version.release': '15'},
  {'version': '2.0.0', 'buildNumber': '42'},
  {'user_id': 'user-1'},
  null,
  PlatformType.android,
  null,
);

void main() {
  late _FakeSlack slack;

  setUp(() async {
    slack = _FakeSlack();
    await slack.start();
  });

  tearDown(() => slack.stop());

  group('CcSlackFeedbackReporter', () {
    test('posts the formatted feedback and reports success', () async {
      final reporter = CcSlackFeedbackReporter(webhookUrl: slack.url);
      const feedback = CcFeedback(text: 'Great', rating: 5);

      expect(await reporter.send(feedback), isTrue);
      expect(slack.posts, [
        CcSlackFeedbackReporter.format(feedback, CcFeedbackLabels.english),
      ]);
    });

    test('accepts a webhook URL wrapped in quotes', () async {
      final reporter = CcSlackFeedbackReporter(webhookUrl: ' "${slack.url}" ');

      expect(await reporter.send(const CcFeedback(text: 'Hi')), isTrue);
      expect(slack.posts, hasLength(1));
    });

    test('drops the same feedback sent twice in a row', () async {
      final reporter = CcSlackFeedbackReporter(webhookUrl: slack.url);

      expect(await reporter.send(const CcFeedback(text: 'Twice')), isTrue);
      expect(await reporter.send(const CcFeedback(text: 'Twice')), isFalse);
      expect(slack.posts, hasLength(1));
    });

    test('reports failure when Slack rejects the post', () async {
      slack.statusCode = 403;
      final reporter = CcSlackFeedbackReporter(webhookUrl: slack.url);

      expect(await reporter.send(const CcFeedback(text: 'Hi')), isFalse);
    });
  });

  group('CcSlackCrashReporter', () {
    Future<void> record(CcSlackCrashReporter reporter, Object error) =>
        reporter.recordError(error, StackTrace.current, reason: 'test');

    test('does not post an error matching ignoredErrors', () async {
      final reporter = CcSlackCrashReporter(
        webhookUrl: slack.url,
        ignoredErrors: [RegExp('firebase_app_check.*Too many attempts')],
      );

      await record(
        reporter,
        Exception('[firebase_app_check/unknown] Too many attempts.'),
      );

      expect(slack.posts, isEmpty);
    });

    test('still posts other errors, including other App Check ones', () async {
      final reporter = CcSlackCrashReporter(
        webhookUrl: slack.url,
        ignoredErrors: [RegExp('firebase_app_check.*Too many attempts')],
      );

      await record(reporter, Exception('Liability 1 not found'));
      await record(
        reporter,
        Exception('[firebase_app_check/unknown] Token expired'),
      );

      expect(slack.posts, hasLength(2));
    });

    test('a plain string pattern matches as a substring', () async {
      final reporter = CcSlackCrashReporter(
        webhookUrl: slack.url,
        ignoredErrors: const ['quota exceeded'],
      );

      await record(reporter, Exception('Gemini quota exceeded for project'));

      expect(slack.posts, isEmpty);
    });

    test('posts everything when nothing is ignored', () async {
      final reporter = CcSlackCrashReporter(webhookUrl: slack.url);

      await record(
        reporter,
        Exception('[firebase_app_check/unknown] Too many attempts.'),
      );

      expect(slack.posts, hasLength(1));
    });
  });

  group('CcSlackHandler', () {
    test('posts what, where, version, device, app check and who', () async {
      final handler = CcSlackHandler(
        webhookUrl: slack.url,
        attestation: const _FakeAttestation(),
      );

      expect(await handler.handle(_report('cart is empty'), null), isTrue);

      final message = slack.posts.single;
      expect(message, contains('Bad state: cart is empty'));
      expect(message, contains('package:shop/cart_page.dart:10:5'));
      expect(message, contains('`2.0.0 (42)`'));
      expect(message, contains('`Pixel 8`'));
      expect(message, contains('`Android 15`'));
      expect(message, contains('*app check*: `Verified`'));
      expect(message, contains('Logged-in User (user-1)'));
    });

    test('throttles the same crash within five minutes', () async {
      final handler = CcSlackHandler(webhookUrl: slack.url);

      expect(await handler.handle(_report('timeout'), null), isTrue);
      expect(await handler.handle(_report('timeout'), null), isTrue);

      expect(slack.posts, hasLength(1));
    });

    test('reports failure when there is no webhook URL', () async {
      final handler = CcSlackHandler(webhookUrl: '');

      expect(await handler.handle(_report('no url'), null), isFalse);
    });
  });
}
