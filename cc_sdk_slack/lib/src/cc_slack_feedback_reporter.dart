import 'package:cc_sdk/export_cc_sdk.dart';

import 'cc_slack_webhook.dart';

/// [CcFeedbackReporter] that posts feedback to a Slack Incoming Webhook.
///
/// An identical message sent again within [duplicateWindow] (a double tap)
/// is dropped. Never throws.
class CcSlackFeedbackReporter implements CcFeedbackReporter {
  CcSlackFeedbackReporter({required String webhookUrl})
    : _webhook = CcSlackWebhook(webhookUrl, logTag: _tag);

  final CcSlackWebhook _webhook;
  String? _lastMessage;
  DateTime? _lastSentAt;

  static const String _tag = 'CcSlackFeedbackReporter';
  static const Duration duplicateWindow = Duration(seconds: 3);

  @override
  Future<bool> send(
    CcFeedback feedback, {
    CcFeedbackLabels labels = CcFeedbackLabels.english,
  }) async {
    if (!_webhook.isConfigured) {
      '❌ Feedback not sent: no Slack webhook URL configured'.Log(_tag);
      return false;
    }

    final message = format(feedback, labels);
    final now = DateTime.now();
    if (_lastMessage == message &&
        _lastSentAt != null &&
        now.difference(_lastSentAt!) < duplicateWindow) {
      '⚠️ Dropped duplicate feedback within ${duplicateWindow.inSeconds}s'
          .Log(_tag);
      return false;
    }
    _lastMessage = message;
    _lastSentAt = now;

    return _webhook.post(message);
  }

  /// The Slack message (mrkdwn) for [feedback].
  static String format(CcFeedback feedback, CcFeedbackLabels labels) {
    String list(List<String> items) =>
        items.isEmpty ? labels.none : items.join(', ');
    final rating = feedback.rating;
    final text = feedback.text.trim();
    return '*${labels.title}*\n'
        '*${labels.rating}:* '
        '${rating == null ? labels.notRated : '⭐ ${rating.toStringAsFixed(1)}/5'}\n'
        '*${labels.praise}:* ${list(feedback.praise)}\n'
        '*${labels.criticism}:* ${list(feedback.criticism)}\n'
        '*${labels.text}:* ${text.isEmpty ? labels.noText : text}';
  }
}
