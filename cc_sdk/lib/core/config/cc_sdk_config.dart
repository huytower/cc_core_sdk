import 'package:flutter/foundation.dart';

/// Settings the SDK needs, supplied once by the app at boot.
///
/// The SDK never reads environment files or `--dart-define` values itself:
/// the app decides where values come from (compile-time defines, remote
/// config, tests) and hands them over here. Until [configure] is called,
/// [current] holds the defaults below, so the SDK also works with no setup.
///
/// ```dart
/// CcSdkConfig.configure(const CcSdkConfig(appName: 'Acme', loginPath: '/sign-in'));
/// ```
@immutable
class CcSdkConfig {
  const CcSdkConfig({
    this.appName = defaultAppName,
    this.enableLogger = !kReleaseMode,
    this.enableLoggerDio = !kReleaseMode,
    this.enableAnalytics = true,
    this.enableCrashReporting = true,
    this.enableCertificatePinning = true,
    this.enableCrashLogUpload = true,
    this.crashLogApiPath = defaultCrashLogApiPath,
    this.mainNavigationPath = '/main_navigation',
    this.loginPath = '/login',
    this.aiModelName = '',
  });

  static const String defaultAppName = 'MyApp';
  static const String defaultCrashLogApiPath = '/client-logs';

  /// App display name used in logs and crash reports.
  final String appName;

  /// Console logging through `.Log()`.
  final bool enableLogger;

  /// HTTP client request/response logging.
  final bool enableLoggerDio;

  final bool enableAnalytics;
  final bool enableCrashReporting;
  final bool enableCertificatePinning;

  /// Upload of crash logs saved on the device to the app's backend.
  final bool enableCrashLogUpload;

  /// Path appended to the API base URL for crash log uploads.
  final String crashLogApiPath;

  /// Route path of the main (home) screen.
  final String mainNavigationPath;

  /// Route path of the login screen.
  final String loginPath;

  /// Model id for the AI capability (`CcAiClient`); blank keeps the
  /// implementation's default.
  final String aiModelName;

  static CcSdkConfig _current = const CcSdkConfig();

  /// The active settings (defaults until [configure] is called).
  static CcSdkConfig get current => _current;

  /// Replaces the active settings; call before any other SDK use at boot.
  static void configure(CcSdkConfig config) => _current = config;
}
