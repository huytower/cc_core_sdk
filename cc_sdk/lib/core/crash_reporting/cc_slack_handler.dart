import 'dart:convert';
import 'dart:io';

import 'package:catcher_2/catcher_2.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:cc_sdk/core/extensions/common/cc_logger_extension.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A [ReportHandler] for Catcher2 that forwards structured crash reports to Slack via
/// an Incoming Webhook URL.
///
/// The webhook URL is loaded from the `SLACK_CRASH_WEBHOOK_URL` environment variable
/// (root `env/.env.*` via [flutter_dotenv]) — it is intentionally **not**
/// hardcoded here to avoid committing secrets to the repository.
class CcSlackHandler extends ReportHandler {
  final String _webhookUrl;

  CcSlackHandler({String? webhookUrl})
    : _webhookUrl = webhookUrl ?? _loadWebhookUrl();

  static String _cleanUrl(String raw) {
    var url = raw.trim();
    if ((url.startsWith('"') && url.endsWith('"')) ||
        (url.startsWith("'") && url.endsWith("'"))) {
      url = url.substring(1, url.length - 1).trim();
    }
    return url;
  }

  static String _loadWebhookUrl() {
    try {
      final raw =
          dotenv.maybeGet('SLACK_CRASH_WEBHOOK_URL', fallback: '') ??
          dotenv.maybeGet('SLACK_WEBHOOK_URL', fallback: '') ??
          '';
      final url = _cleanUrl(raw);
      '[CatcherSlack] Loaded SLACK_CRASH_WEBHOOK_URL: ${url.isNotEmpty ? "(present, length=${url.length})" : "(EMPTY)"}'
          .Log('CcSlackHandler');
      return url;
    } catch (e) {
      '[CatcherSlack] Error loading SLACK_CRASH_WEBHOOK_URL: $e'.Log(
        'CcSlackHandler',
      );
      return '';
    }
  }

  @override
  Future<bool> handle(Report report, _) async {
    '[CatcherSlack] 🚨 Handling crash report with Catcher2...'.Log(
      'CcSlackHandler',
    );

    if (_webhookUrl.isEmpty) {
      '[CatcherSlack] ❌ Cannot send report to Slack: SLACK_WEBHOOK_URL is empty!'
          .Log('CcSlackHandler');
      return false;
    }

    try {
      final messageText = _formatStructuredSlackMessage(report);
      return await _postToSlack(_webhookUrl, messageText);
    } catch (e) {
      '[CatcherSlack] ❌ Failed to process crash report: $e'.Log(
        'CcSlackHandler',
      );
      return false;
    }
  }

  static String _formatStructuredSlackMessage(Report report) {
    final rawError = report.error?.toString() ?? 'Unknown Error';
    final errorLines = rawError.split('\n');
    final errorMsg = errorLines.first.trim();
    final stackText = report.stackTrace?.toString() ?? '';

    // Infer location dynamically from stack trace
    String where = 'Unknown location';
    final stackLines = stackText.split('\n');
    for (final line in stackLines) {
      final trimmed = line.trim();
      if (trimmed.contains('package:') &&
          !trimmed.contains('package:flutter/') &&
          !trimmed.contains('package:catcher_2/')) {
        final match = RegExp(
          r'#\d+\s+(.*?)\s+\((package:.*?)\)',
        ).firstMatch(trimmed);
        if (match != null) {
          where = '${match.group(2)} [${match.group(1)}]';
          break;
        } else if (trimmed.contains('package:')) {
          where = trimmed;
          break;
        }
      }
    }

    // Who dynamically
    final userEmail =
        report.customParameters['user_email'] ??
        report.customParameters['email'] ??
        report.customParameters['user_id'] ??
        report.customParameters['uid'];

    final String who;
    if (userEmail != null && userEmail.toString().isNotEmpty) {
      who = 'Logged-in User ($userEmail)';
    } else {
      final deviceModel =
          report.deviceParameters['model'] ??
          report.deviceParameters['device'] ??
          report.deviceParameters['id'] ??
          'Device';
      who = 'Anonymous Guest ($deviceModel)';
    }

    // When dynamically
    final localTime = report.dateTime.toLocal();
    final year = localTime.year;
    final month = _twoDigits(localTime.month);
    final day = _twoDigits(localTime.day);
    final hour = _twoDigits(localTime.hour);
    final minute = _twoDigits(localTime.minute);
    final amPm = localTime.hour >= 12 ? 'PM' : 'AM';
    final when = '$year-$month-$day $hour:$minute $amPm (GMT+7)';

    final buffer = StringBuffer()
      ..writeln('*🚨 Crash caught by Catcher2*')
      ..writeln("• *what's crash*: `$errorMsg`");

    buffer.writeln('• *where*: `$where`');

    buffer
      ..writeln('• *who*: $who')
      ..writeln('• *when*: $when');

    return buffer.toString().trim();
  }

  static String _twoDigits(int n) => n >= 10 ? '$n' : '0$n';

  static Future<bool> _postToSlack(String rawUrl, String messageText) async {
    final cleanUrl = _cleanUrl(rawUrl);
    '[CatcherSlack] 📤 Sending crash report to Slack Webhook: "$cleanUrl" (length=${cleanUrl.length})...'
        .Log('CcSlackHandler');

    final uri = Uri.tryParse(cleanUrl);
    if (uri == null || !uri.hasScheme) {
      '[CatcherSlack] ❌ Invalid Webhook URL URI: "$cleanUrl"'.Log(
        'CcSlackHandler',
      );
      return false;
    }

    final client = HttpClient();
    try {
      final request = await client.postUrl(uri);
      request.headers.set('content-type', 'application/json; charset=utf-8');
      request.headers.set(
        'user-agent',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      );
      final payload = jsonEncode({'text': messageText});
      request.write(payload);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      '[CatcherSlack] ✅ Crash report posted to Slack successfully (status: ${response.statusCode}, body: "$responseBody")'
          .Log('CcSlackHandler');
      return response.statusCode == 200;
    } catch (e) {
      '[CatcherSlack] ❌ HttpClient Error: $e'.Log('CcSlackHandler');
      return false;
    } finally {
      client.close();
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
    PlatformType.android,
    PlatformType.iOS,
  ];
}
