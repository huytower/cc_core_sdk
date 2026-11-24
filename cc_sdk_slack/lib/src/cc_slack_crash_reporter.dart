import 'package:cc_sdk/export_cc_sdk.dart';

import 'cc_slack_alert_support.dart';
import 'cc_slack_webhook.dart';

/// [CcCrashReporter] that posts each recorded error to a Slack Incoming
/// Webhook: errors caught in code (`recordError` from a catch block) as well
/// as uncaught ones forwarded by `CcCrashReporterHandler`.
///
/// The same error (first line of its message) is posted at most once per
/// [CcSlackAlertSupport.throttleWindow], shared with [CcSlackHandler]. Breadcrumbs
/// ([log]) are not sent. Errors matching [ignoredErrors] are not posted at
/// all (other reporters in a composite still get them). Never throws.
///
/// ```dart
/// CcCompositeCrashReporter([
///   crashlytics,
///   CcSlackCrashReporter(
///     webhookUrl: url,
///     deviceInfo: deviceInfo,
///     ignoredErrors: [RegExp('Too many attempts')],
///   ),
/// ]);
/// ```
class CcSlackCrashReporter implements CcCrashReporter {
  CcSlackCrashReporter({
    required String webhookUrl,
    CcDeviceInfoService? deviceInfo,
    CcAppAttestation? attestation,
    this.ignoredErrors = const [],
  }) : _webhook = CcSlackWebhook(webhookUrl, logTag: _tag),
       _deviceInfo = deviceInfo,
       _attestation = attestation;

  /// Errors whose text matches one of these are not posted: a [String] is a
  /// substring, a [RegExp] is searched. For expected, transient noise such as
  /// a rate limit, which says nothing about a bug in the app.
  final List<Pattern> ignoredErrors;

  final CcSlackWebhook _webhook;

  /// Adds app version and device to each alert; omitted when null.
  final CcDeviceInfoService? _deviceInfo;

  /// Adds the attestation state to each alert; omitted when null.
  final CcAppAttestation? _attestation;

  static const String _tag = 'CcSlackCrashReporter';

  @override
  Future<void> log(String message) async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
    bool fatal = false,
  }) async {
    try {
      if (!_webhook.isConfigured) {
        '❌ Error not sent: no Slack webhook URL configured'.Log(_tag);
        return;
      }
      if (CcSlackAlertSupport.isIgnored(error, ignoredErrors)) {
        '🔇 Ignored error, not sent: ${CcSlackAlertSupport.headline(error)}'
            .Log(_tag);
        return;
      }
      final key = CcSlackAlertSupport.headline(error);
      if (CcSlackAlertSupport.isThrottled(key)) {
        '⏳ Throttled duplicate alert for "$key"'.Log(_tag);
        return;
      }
      final device = await _deviceSummary();
      final appCheck = await _attestation?.statusDescription() ?? 'n/a';
      final message = format(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
        device: device,
        appCheck: appCheck,
        time: DateTime.now(),
      );
      if (await _webhook.post(message)) {
        CcSlackAlertSupport.markSent(key);
      }
    } catch (e) {
      '❌ Failed to send error alert: $e'.Log(_tag);
    }
  }

  /// The Slack message (mrkdwn) for one error.
  static String format(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
    required bool fatal,
    required String device,
    required String appCheck,
    required DateTime time,
  }) {
    final title = fatal ? '*🚨 Fatal error*' : '*⚠️ Error reported*';
    final where = CcSlackAlertSupport.whereFromStack(
      stackTrace?.toString() ?? '',
    );
    final when = CcSlackAlertSupport.localTimestamp(time);
    return [
      title,
      "• *what's wrong*: `${CcSlackAlertSupport.headline(error)}`",
      '• *where*: `$where`',
      '• *reason*: `$reason`',
      '• *device*: $device',
      '• *app check*: `$appCheck`; *when*: $when',
    ].join('\n');
  }

  Future<String> _deviceSummary() async {
    final helper = _deviceInfo;
    if (helper == null) return 'n/a';
    try {
      final d = await helper.getDeviceEntity();
      final model = [d.brand, d.model].whereType<String>().join(' ').trim();
      final os = [d.osName, d.osVersion].whereType<String>().join(' ').trim();
      return '*app version*: `${d.appVersion ?? 'n/a'}`; '
          '*device model*: `${model.isEmpty ? 'n/a' : model}`; '
          '*os version*: `${os.isEmpty ? 'n/a' : os}`';
    } catch (_) {
      return 'n/a';
    }
  }
}
