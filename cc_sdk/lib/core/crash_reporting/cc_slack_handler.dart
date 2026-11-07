import 'dart:convert';
import 'dart:io';

import 'package:catcher_2/catcher_2.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:cc_sdk/core/extensions/common/cc_logger_extension.dart';
import 'package:cc_sdk/core/helper/cc_app_check_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A [ReportHandler] for Catcher2 that forwards structured crash reports to Slack via
/// an Incoming Webhook URL.
///
/// The webhook URL is loaded from the `SLACK_CRASH_WEBHOOK_URL` environment variable
/// (root `env/.env.*` via [flutter_dotenv]) — it is intentionally **not**
/// hardcoded here to avoid committing secrets to the repository.
class CcSlackHandler extends ReportHandler {
  final String _webhookUrl;

  /// Cooldown map to prevent spamming Slack with identical error reports.
  static final Map<String, DateTime> _lastReported = {};
  static const Duration _throttleDuration = Duration(minutes: 5);

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

    final rawError = report.error?.toString() ?? 'Unknown Error';
    final errorMsg = rawError.split('\n').first.trim();
    final errorKey = errorMsg;

    final now = DateTime.now();
    final lastTime = _lastReported[errorKey];
    if (lastTime != null && now.difference(lastTime) < _throttleDuration) {
      '[CatcherSlack] ⏳ Throttling duplicate Slack alert for "$errorKey" (reported ${now.difference(lastTime).inSeconds}s ago)'
          .Log('CcSlackHandler');
      return true;
    }

    try {
      final appCheckStatus = await CcAppCheckHelper.getAppCheckStatus();
      final messageText = _formatStructuredSlackMessage(
        report,
        appCheckStatus: appCheckStatus,
      );
      final success = await _postToSlack(_webhookUrl, messageText);
      if (success) {
        _lastReported[errorKey] = now;
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
      ..writeln("• *what's crash*: `$errorMsg`")
      ..writeln('• *where*: `$where`')
      ..writeln(
        '• *app version*: `$versionStr`; *device model*: `$deviceName`; *os version*: `$osVersion`',
      )
      ..writeln('• *app check*: `$appCheckStatus`; *who*: $who; *when*: $when');

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
