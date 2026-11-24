import 'package:catcher_2/catcher_2.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:cc_sdk/export_cc_sdk.dart';

import 'cc_slack_alert_support.dart';
import 'cc_slack_webhook.dart';

/// A [ReportHandler] for Catcher2 that forwards structured crash reports to Slack via
/// an Incoming Webhook URL.
///
/// The app passes the webhook URL (a secret, never hardcoded). Add it to the
/// release/profile handlers, e.g.
/// `CcCatcherBootstrap.releaseOptions(file, remoteHandlers: [CcSlackHandler(
/// webhookUrl: url, attestation: attestation)])`.
class CcSlackHandler extends ReportHandler {
  final CcSlackWebhook _webhook;

  /// Adds the attestation state to each report; omitted when null.
  final CcAppAttestation? _attestation;

  CcSlackHandler({required String webhookUrl, CcAppAttestation? attestation})
    : _webhook = CcSlackWebhook(webhookUrl, logTag: 'CcSlackHandler'),
      _attestation = attestation;

  @override
  Future<bool> handle(Report report, _) async {
    '[CatcherSlack] 🚨 Handling crash report with Catcher2...'.Log(
      'CcSlackHandler',
    );

    if (!_webhook.hasConfigured) {
      '[CatcherSlack] ❌ Cannot send report to Slack: no webhook URL configured'
          .Log('CcSlackHandler');
      return false;
    }

    final errorKey = CcSlackAlertSupport.headline(report.error);
    if (CcSlackAlertSupport.isThrottled(errorKey)) {
      '[CatcherSlack] ⏳ Throttling duplicate Slack alert for "$errorKey"'.Log(
        'CcSlackHandler',
      );
      return true;
    }

    try {
      final appCheckStatus = await _attestation?.statusDescription() ?? 'n/a';
      final messageText = _formatStructuredSlackMessage(
        report,
        appCheckStatus: appCheckStatus,
      );
      final success = await _webhook.post(messageText);
      if (success) {
        CcSlackAlertSupport.markSent(errorKey);
      }
      return success;
    } catch (e) {
      '[CatcherSlack] ❌ Failed to process crash report: $e'.Log(
        'CcSlackHandler',
      );
      return false;
    }
  }

  static String _translateIosMachine(String machine) {
    final clean = machine.trim();
    final Map<String, String> iosModels = {
      'iPhone10,1': 'iPhone 8',
      'iPhone10,4': 'iPhone 8',
      'iPhone10,2': 'iPhone 8 Plus',
      'iPhone10,5': 'iPhone 8 Plus',
      'iPhone10,3': 'iPhone X',
      'iPhone10,6': 'iPhone X',
      'iPhone11,2': 'iPhone XS',
      'iPhone11,4': 'iPhone XS Max',
      'iPhone11,6': 'iPhone XS Max',
      'iPhone11,8': 'iPhone XR',
      'iPhone12,1': 'iPhone 11',
      'iPhone12,3': 'iPhone 11 Pro',
      'iPhone12,5': 'iPhone 11 Pro Max',
      'iPhone12,8': 'iPhone SE (2nd gen)',
      'iPhone13,1': 'iPhone 12 mini',
      'iPhone13,2': 'iPhone 12',
      'iPhone13,3': 'iPhone 12 Pro',
      'iPhone13,4': 'iPhone 12 Pro Max',
      'iPhone14,4': 'iPhone 13 mini',
      'iPhone14,5': 'iPhone 13',
      'iPhone14,2': 'iPhone 13 Pro',
      'iPhone14,3': 'iPhone 13 Pro Max',
      'iPhone14,6': 'iPhone SE (3rd gen)',
      'iPhone14,7': 'iPhone 14',
      'iPhone14,8': 'iPhone 14 Plus',
      'iPhone15,2': 'iPhone 14 Pro',
      'iPhone15,3': 'iPhone 14 Pro Max',
      'iPhone15,4': 'iPhone 15',
      'iPhone15,5': 'iPhone 15 Plus',
      'iPhone16,1': 'iPhone 15 Pro',
      'iPhone16,2': 'iPhone 15 Pro Max',
      'iPhone17,1': 'iPhone 16 Pro',
      'iPhone17,2': 'iPhone 16 Pro Max',
      'iPhone17,3': 'iPhone 16',
      'iPhone17,4': 'iPhone 16 Plus',
    };
    final prettyName = iosModels[clean];
    if (prettyName != null) {
      return '$prettyName ($clean)';
    }
    return clean;
  }

  static String _formatStructuredSlackMessage(
    Report report, {
    required String appCheckStatus,
  }) {
    final errorMsg = CcSlackAlertSupport.headline(report.error);
    final where = CcSlackAlertSupport.whereFromStack(
      report.stackTrace?.toString() ?? '',
    );

    // Application build version & number
    final appVersion =
        report.applicationParameters['version'] ??
        report.applicationParameters['appVersion'] ??
        report.customParameters['app_version'] ??
        '1.0.0';
    final buildNumber =
        report.applicationParameters['buildNumber'] ??
        report.applicationParameters['build_number'] ??
        report.customParameters['build_number'] ??
        '';
    final versionStr = buildNumber.toString().isNotEmpty
        ? '$appVersion ($buildNumber)'
        : '$appVersion';

    // Device & OS details extraction
    final deviceMap = report.deviceParameters;
    String deviceName = 'Unknown Device';
    String osVersion = 'Unknown OS';

    String getVal(List<String> keys) {
      for (final key in keys) {
        if (deviceMap.containsKey(key) && deviceMap[key] != null) {
          final v = deviceMap[key].toString().trim();
          if (v.isNotEmpty && v != 'null') return v;
        }
      }
      return '';
    }

    String machine = getVal(['utsname.machine', 'machine']);
    if (machine.isEmpty && deviceMap['utsname'] is Map) {
      machine =
          (deviceMap['utsname'] as Map)['machine']?.toString().trim() ?? '';
    }

    final sysName = getVal(['systemName', 'system_name', 'os']);
    final sysVer = getVal([
      'systemVersion',
      'system_version',
      'version.release',
      'version',
    ]);

    if (sysName.toLowerCase().contains('ios') ||
        deviceMap.containsKey('utsname') ||
        deviceMap.containsKey('systemName')) {
      // iOS
      final name = getVal(['name', 'localizedModel', 'model']);
      final prettyMachine = _translateIosMachine(machine);
      if (prettyMachine.isNotEmpty) {
        deviceName = prettyMachine;
      } else if (name.isNotEmpty) {
        deviceName = name;
      } else {
        deviceName = 'iPhone';
      }

      final osName = sysName.isNotEmpty ? sysName : 'iOS';
      osVersion = sysVer.isNotEmpty ? '$osName $sysVer' : osName;
    } else if (deviceMap.containsKey('version.release') ||
        deviceMap.containsKey('brand') ||
        deviceMap.containsKey('manufacturer')) {
      // Android
      final brand = getVal(['brand', 'manufacturer']);
      final model = getVal(['model']);
      deviceName = '$brand $model'.trim();
      if (deviceName.isEmpty) deviceName = 'Android Device';

      final release = getVal(['version.release', 'release']);
      final sdk = getVal(['version.sdkInt', 'sdkInt']);
      final sdkStr = sdk.isNotEmpty ? ' (SDK $sdk)' : '';
      osVersion = release.isNotEmpty ? 'Android $release$sdkStr' : 'Android';
    } else {
      deviceName = getVal(['model', 'name', 'device']);
      if (deviceName.isEmpty) deviceName = 'Device';
      osVersion = getVal(['systemVersion', 'osVersion', 'os']);
      if (osVersion.isEmpty) osVersion = 'OS';
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
      who = 'Anonymous Guest';
    }

    final when =
        '${CcSlackAlertSupport.localTimestamp(report.dateTime)} '
        '(${CcSlackAlertSupport.gmtOffset(report.dateTime)})';

    final buffer = StringBuffer()
      ..writeln('*🚨 Crash caught by Catcher2*')
      ..writeln("• *what's crash*: `$errorMsg`")
      ..writeln('• *where*: `$where`')
      ..writeln(
        '• *app version*: `$versionStr`; *device model*: `$deviceName`; *os version*: `$osVersion`',
      )
      ..writeln('• *app check*: `$appCheckStatus`; *who*: $who; *when*: $when');

    return buffer.toString().trim();
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
    PlatformType.android,
    PlatformType.iOS,
  ];
}
