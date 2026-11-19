import 'dart:convert';
import 'dart:io';

import 'package:catcher_2/catcher_2.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:cc_sdk/core/crash_reporting/cc_crash_reporter.dart';
import 'package:cc_sdk/core/crash_reporting/cc_slack_handler.dart';
import 'package:cc_sdk/core/extensions/export_cc_extensions.dart';
import 'package:cc_sdk/core/security/cc_app_attestation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// Custom ConsoleHandler that logs device info as JSON instead of individual lines
class _JsonConsoleHandler extends ConsoleHandler {
  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    // Check if this is a device info report
    if (report.error == null && report.stackTrace == null) {
      // This is likely a device info report, log as JSON
      final deviceInfo = _extractDeviceInfo(report);
      if (deviceInfo.isNotEmpty) {
        '------- DEVICE INFO (JSON) -------'.Log('device-info');
        const JsonEncoder.withIndent(
          '  ',
        ).convert(deviceInfo).Log('device-info');
        '----------------------------------'.Log('device-info');
        return true;
      }
    }

    // Default handling for other reports
    return await super.handle(report, context);
  }

  Map<String, dynamic> _extractDeviceInfo(Report report) {
    final deviceInfo = <String, dynamic>{};

    // Extract custom parameters which may contain device info
    if (report.customParameters.isNotEmpty) {
      deviceInfo.addAll(report.customParameters);
    }

    // Extract device info from the report
    if (report.deviceParameters.isNotEmpty) {
      deviceInfo.addAll(report.deviceParameters);
    }

    return deviceInfo;
  }
}

/// Custom FileHandler wrapper to prevent concurrent access to the same file
/// which causes "StreamSink is bound to a stream" errors in Catcher2.
class _SynchronizedFileHandler extends ReportHandler {
  final FileHandler _inner;
  Future<void>? _currentOperation;

  _SynchronizedFileHandler(File logFile, {bool printLogs = false})
    : _inner = FileHandler(logFile, printLogs: printLogs);

  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    while (_currentOperation != null) {
      await _currentOperation;
    }

    // ignore: use_build_context_synchronously
    final operation = _inner.handle(report, context);
    _currentOperation = operation;
    try {
      return await operation;
    } finally {
      _currentOperation = null;
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() => _inner.getSupportedPlatforms();
}

/// Builds [Catcher2Options] for debug / release with file + console (debug) handlers.
abstract final class CcCatcherBootstrap {
  CcCatcherBootstrap._();

  static _SynchronizedFileHandler? _cachedHandler;

  static _SynchronizedFileHandler _getHandler(
    File logFile, {
    bool printLogs = false,
  }) {
    return _cachedHandler ??= _SynchronizedFileHandler(
      logFile,
      printLogs: printLogs,
    );
  }

  /// Handlers: console (debug only), the crash log file, [crashReporter] when
  /// given (e.g. Crashlytics via `CcCrashReporter` from DI), and Slack (release
  /// and profile only).
  ///
  /// Debug builds report locally only (console + log file + [crashReporter]).
  /// No Slack: debug runs on emulators fail often and expectedly (e.g. an
  /// unregistered App Check debug token at launch), which would spam the
  /// crash channel. Release and profile builds still post to Slack.
  static Catcher2Options debugOptions(
    File logFile, {
    CcCrashReporter? crashReporter,
  }) => Catcher2Options(SilentReportMode(), [
    _JsonConsoleHandler(),
    _getHandler(logFile, printLogs: kDebugMode),
    if (crashReporter != null) CcCrashReporterHandler(crashReporter),
  ]);

  /// [attestation], when given, adds its state to each Slack report.
  static Catcher2Options releaseOptions(
    File logFile, {
    CcCrashReporter? crashReporter,
    CcAppAttestation? attestation,
  }) => Catcher2Options(SilentReportMode(), [
    _getHandler(logFile, printLogs: false),
    if (crashReporter != null) CcCrashReporterHandler(crashReporter),
    CcSlackHandler(attestation: attestation),
  ]);

  static Catcher2Options profileOptions(
    File logFile, {
    CcCrashReporter? crashReporter,
    CcAppAttestation? attestation,
  }) => releaseOptions(
    logFile,
    crashReporter: crashReporter,
    attestation: attestation,
  );
}
