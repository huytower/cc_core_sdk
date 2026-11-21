import 'package:flutter/foundation.dart';

/// The two settings every SDK package may read without injection: the app's
/// name (logs, crash reports) and whether `.Log()` writes anything.
///
/// They stay ambient because `.Log()` is an extension on every value and can
/// take no constructor argument. Everything else is configured where it is
/// used: a capability takes its settings through its constructor (for example
/// `CcFirebaseAiConfig` in `cc_sdk_firebase`), and app concerns (routes,
/// upload paths, product flags) belong to the app.
///
/// Until [configure] is called, [current] holds the defaults below, so the SDK
/// also works with no setup.
///
/// ```dart
/// CcSdkConfig.configure(const CcSdkConfig(appName: 'Acme'));
/// ```
@immutable
class CcSdkConfig {
  const CcSdkConfig({
    this.appName = defaultAppName,
    this.enableLogger = !kReleaseMode,
  });

  static const String defaultAppName = 'MyApp';

  /// App display name used in logs and crash reports.
  final String appName;

  /// Console logging through `.Log()`.
  final bool enableLogger;

  static CcSdkConfig _current = const CcSdkConfig();

  /// The active settings (defaults until [configure] is called).
  static CcSdkConfig get current => _current;

  /// Replaces the active settings; call before any other SDK use at boot.
  static void configure(CcSdkConfig config) => _current = config;
}
