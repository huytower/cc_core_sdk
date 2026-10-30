import 'dart:convert';
import 'dart:io';

import 'package:cc_sdk/core/extensions/common/cc_logger_extension.dart';
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

  static String? _webhookUrl;
  static String? _lastPayload;
  static DateTime? _lastSentAt;

  static String _cleanUrl(String raw) {
    var url = raw.trim();
    if ((url.startsWith('"') && url.endsWith('"')) ||
        (url.startsWith("'") && url.endsWith("'"))) {
      url = url.substring(1, url.length - 1).trim();
    }
    return url;
  }

  static String _loadWebhookUrl() {
    if (_webhookUrl != null && _webhookUrl!.isNotEmpty) return _webhookUrl!;
    try {
      final raw =
          dotenv.maybeGet('SLACK_FEEDBACK_WEBHOOK_URL', fallback: '') ??
          dotenv.maybeGet('SLACK_WEBHOOK_URL', fallback: '') ??
          '';
      _webhookUrl = _cleanUrl(raw);
      '[SlackFeedbackWorkflow] Loaded SLACK_FEEDBACK_WEBHOOK_URL: ${_webhookUrl?.isNotEmpty == true ? "(present, length=${_webhookUrl!.length})" : "(EMPTY)"}'
          .Log('CcSlackFeedbackHelper');
    } catch (e) {
      '[SlackFeedbackWorkflow] Error loading SLACK_FEEDBACK_WEBHOOK_URL: $e'
          .Log('CcSlackFeedbackHelper');
      _webhookUrl = '';
    }
    return _webhookUrl ?? '';
  }

  static const Map<String, Map<String, String>> _slackLabels = {
    'vi': {
      'title': '📝 Đánh giá & Góp ý người dùng',
      'rating': 'Đánh giá',
      'praise': 'Khen ngợi',
      'criticism': 'Góp ý',
      'feedback': 'Nội dung góp ý',
      'none': '(không có)',
      'no_text': '(chưa nhập)',
    },
    'en': {
      'title': '📝 User Feedback',
      'rating': 'Rating',
      'praise': 'Praise',
      'criticism': 'Criticism',
      'feedback': 'Typing feedback',
      'none': '(none)',
      'no_text': '(no text)',
    },
    'ja': {
      'title': '📝 ユーザーフィードバック',
      'rating': '評価',
      'praise': '良かった点',
      'criticism': '改善点',
      'feedback': 'フィードバック内容',
      'none': '(なし)',
      'no_text': '(未入力)',
    },
    'ko': {
      'title': '📝 사용자 피드백',
      'rating': '평가',
      'praise': '칭찬',
      'criticism': '개선 요청',
      'feedback': '피드백 내용',
      'none': '(없음)',
      'no_text': '(미입력)',
    },
    'zh': {
      'title': '📝 用户反馈',
      'rating': '评分',
      'praise': '赞扬',
      'criticism': '批评/建议',
      'feedback': '反馈内容',
      'none': '(无)',
      'no_text': '(未输入)',
    },
  };

  /// Posts [feedbackText] together with [praiseLabels], [criticismLabels],
  /// and [averageRating] to Slack localized according to [languageCode].
  static Future<void> sendUserFeedback({
    required String feedbackText,
    required List<String> praiseLabels,
    required List<String> criticismLabels,
    double? averageRating,
    String languageCode = 'vi',
  }) async {
    '[SlackFeedbackWorkflow] 🚀 Starting sendUserFeedback (lang: $languageCode)...'
        .Log('CcSlackFeedbackHelper');

    final rawUrl = _loadWebhookUrl();
    if (rawUrl.isEmpty) {
      '[SlackFeedbackWorkflow] ❌ CANNOT SEND: SLACK_WEBHOOK_URL is empty or not configured in .env!'
          .Log('CcSlackFeedbackHelper');
      return;
    }

    final labels = _slackLabels[languageCode] ?? _slackLabels['vi']!;

    final praiseText = praiseLabels.isNotEmpty
        ? praiseLabels.join(', ')
        : labels['none']!;
    final criticismText = criticismLabels.isNotEmpty
        ? criticismLabels.join(', ')
        : labels['none']!;
    final ratingText = averageRating != null
        ? '⭐ ${averageRating.toStringAsFixed(1)}/5'
        : '(not rated)';
    final safeText = feedbackText.trim().isNotEmpty
        ? feedbackText.trim()
        : labels['no_text']!;

    final messageText =
        '*${labels['title']}*\n'
        '*${labels['rating']}:* $ratingText\n'
        '*${labels['praise']}:* $praiseText\n'
        '*${labels['criticism']}:* $criticismText\n'
        '*${labels['feedback']}:* $safeText';

    // Deduplication check: ignore identical payload if sent within 3 seconds
    final now = DateTime.now();
    if (_lastPayload == messageText &&
        _lastSentAt != null &&
        now.difference(_lastSentAt!).inSeconds < 3) {
      '[SlackFeedbackWorkflow] ⚠️ Dropped duplicate feedback submission within 3s window.'
          .Log('CcSlackFeedbackHelper');
      return;
    }

    _lastPayload = messageText;
    _lastSentAt = now;

    await _postToSlack(rawUrl, messageText);
  }

  static Future<bool> _postToSlack(String rawUrl, String messageText) async {
    final cleanUrl = _cleanUrl(rawUrl);
    '[SlackFeedbackWorkflow] 📤 Sending POST request to Slack Webhook: "$cleanUrl" (length=${cleanUrl.length})...'
        .Log('CcSlackFeedbackHelper');

    final uri = Uri.tryParse(cleanUrl);
    if (uri == null || !uri.hasScheme) {
      '[SlackFeedbackWorkflow] ❌ Invalid Webhook URL URI: "$cleanUrl"'.Log(
        'CcSlackFeedbackHelper',
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

      '[SlackFeedbackWorkflow] ✅ Slack HTTP Response Status: ${response.statusCode}, Body: "$responseBody"'
          .Log('CcSlackFeedbackHelper');

      return response.statusCode == 200;
    } catch (e) {
      '[SlackFeedbackWorkflow] ❌ HttpClient Error: $e'.Log(
        'CcSlackFeedbackHelper',
      );
      return false;
    } finally {
      client.close();
    }
  }
}
