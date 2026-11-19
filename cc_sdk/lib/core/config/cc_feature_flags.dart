import 'package:cc_sdk/core/config/cc_sdk_config.dart';

/// Read-only view of the SDK's feature flags.
///
/// Values come from [CcSdkConfig.current], which the app sets at boot with
/// [CcSdkConfig.configure].
///
/// ```dart
/// if (CcFeatureFlags.isEnableLogger) { ... }
/// ```
abstract final class CcFeatureFlags {
  CcFeatureFlags._();

  static CcSdkConfig get _config => CcSdkConfig.current;

  /// Whether logging is enabled
  static bool get isEnableLogger => _config.enableLogger;

  /// Whether Dio HTTP client logging is enabled
  static bool get isEnableLoggerDio => _config.enableLoggerDio;

  /// Whether analytics is enabled
  static bool get isAnalyticsEnabled => _config.enableAnalytics;

  /// Whether crash reporting is enabled
  static bool get isCrashReportingEnabled => _config.enableCrashReporting;

  /// Whether certificate pinning is enabled for HTTP requests
  static bool get isCertificatePinningEnabled =>
      _config.enableCertificatePinning;

  /// Whether VIP mode is enabled.
  ///
  /// Product-specific: an app should define this in its own flags.
  @Deprecated(
    'Product-specific flag; define it in the app. Removed in the next major version.',
  )
  static bool get isVipModeEnabled =>
      const bool.fromEnvironment('ENABLE_VIP_MODE');
}
