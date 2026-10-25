import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Helper for posting *user feedback* (praise/criticism + free-text) to Slack
/// via an Incoming Webhook URL.
///
/// The webhook URL is loaded from the `SLACK_WEBHOOK_URL` environment variable
/// (root `env/.env.*` via [flutter_dotenv]) — it is intentionally **not**
/// hardcoded here to avoid committing secrets to the repository.
///
/// Best-effort only: a failure to post must never mask or block the feedback
/// flow shown to the user.
class CcSlackFeedbackHelper {
  CcSlackFeedbackHelper._();

  static const _defaultChannel = '#user_feedback';

  static String? _webhookUrl;

  static String? _loadWebhookUrl() {
    if (_webhookUrl != null) return _webhookUrl;
    try {
      _webhookUrl = dotenv.maybeGet('SLACK_WEBHOOK_URL', fallback: '');
    } catch (_) {
      _webhookUrl = '';
    }
    return _webhookUrl;
  }

  /// Posts [feedbackText] together with the selected [selectedKeys] (praise or
  /// criticism keys) and the existing [averageRating] (from ReviewsSummaryCard)
  /// to Slack.
  static Future<void> sendUserFeedback({
    required String feedbackText,
    required List<String> selectedKeys,
    required bool isPraise,
    double? averageRating,
  }) async {
    final webhookUrl = _loadWebhookUrl();
    if (webhookUrl == null || webhookUrl.isEmpty) return;

    final type = isPraise ? '👍 Praise' : '👎 Criticism';
    final keysText = selectedKeys.isNotEmpty
        ? selectedKeys.join(', ')
        : '(none)';
    final ratingText = averageRating != null
        ? '⭐ ${averageRating.toStringAsFixed(1)}/5'
        : '(not rated)';
    final safeText = feedbackText.trim().isNotEmpty
        ? feedbackText.trim()
        : '(no text)';

    final payload = jsonEncode({
      'text': '*📝 User Feedback*\n*Type:* $type\n*Rating:* $ratingText\n*Selected:* $keysText\n*Feedback:* $safeText',
      'channel': _defaultChannel,
    });

    try {
      await Dio().post(
        webhookUrl,
        data: payload,
        options: Options(
          headers: {'content-type': 'application/json'},
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );
    } catch (_) {
      // Best-effort — reporting must never throw into the caller's flow.
    }
  }
}
