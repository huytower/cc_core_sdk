import 'dart:convert';

import 'package:catcher_2/catcher_2.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A [ReportHandler] for Catcher2 that forwards crash reports to Slack via
/// an Incoming Webhook URL.
///
/// The webhook URL is loaded from the `SLACK_WEBHOOK_URL` environment variable
/// (root `env/.env.*` via [flutter_dotenv]) — it is intentionally **not**
/// hardcoded here to avoid committing secrets to the repository.
class CcSlackHandler extends ReportHandler {
  final String _webhookUrl;
  final Dio _dio;

  CcSlackHandler({String? webhookUrl, Dio? dio})
    : _webhookUrl = webhookUrl ?? _loadWebhookUrl(),
      _dio = dio ?? Dio();

  static String _loadWebhookUrl() {
    try {
      return dotenv.maybeGet('SLACK_WEBHOOK_URL', fallback: '') ?? '';
    } catch (_) {
      return '';
    }
  }

  @override
  Future<bool> handle(Report report, _) async {
    if (_webhookUrl.isEmpty) {
      return false;
    }

    try {
      final errorText = report.error != null ? report.error.toString() : 'unknown';
      final stackText = report.stackTrace != null ? report.stackTrace.toString() : 'no stack trace';
      final deviceInfo = report.deviceParameters.isNotEmpty
          ? '\n*Device:* ${report.deviceParameters.entries.take(3).map((e) => '${e.key}=${e.value}').join(', ')}'
          : '';
      final customInfo = report.customParameters.isNotEmpty
          ? '\n*Extra:* ${report.customParameters.entries.take(3).map((e) => '${e.key}=${e.value}').join(', ')}'
          : '';

      final payload = jsonEncode({
        'text': '*🚨 Crash caught by Catcher2*\n*Error:* $errorText$deviceInfo$customInfo\n*Stack:*\n\`\`\`$stackText\`\`\`',
        'channel': '#user_feedback',
      });

      await _dio.post(
        _webhookUrl,
        data: payload,
        options: Options(
          headers: {'content-type': 'application/json'},
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );
      return true;
    } catch (_) {
      // Best-effort — reporting must never throw into Catcher2's pipeline.
      return false;
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.android, PlatformType.iOS];
}
