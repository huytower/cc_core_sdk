import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Manages feature flags for the application.
///
/// Feature flags can be controlled via environment variables or have default values
/// based on the current environment.
///
/// Example usage:
/// ```dart
/// if (CcFeatureFlags.isEnableLogger) {
///   // Enable logging
/// }
/// ```
abstract final class CcFeatureFlags {
  CcFeatureFlags._();

  /// Whether logging is enabled
  static bool get isEnableLogger => _getBool('ENABLE_LOGGER', !kReleaseMode);

  /// Whether Dio HTTP client logging is enabled
  static bool get isEnableLoggerDio =>
      _getBool('ENABLE_LOGGER_DIO', !kReleaseMode);

  /// Whether analytics is enabled
  static bool get isAnalyticsEnabled => _getBool('ENABLE_ANALYTICS', true);

  /// Whether crash reporting is enabled
  static bool get isCrashReportingEnabled =>
      _getBool('ENABLE_CRASH_REPORTING', true);

  /// Whether certificate pinning is enabled for HTTP requests
  static bool get isCertificatePinningEnabled =>
      _getBool('ENABLE_CERT_PINNING', true);

  /// Whether QA-only debug escape hatches (e.g. manual VIP/user-level
  /// overrides) are shown. Env-driven rather than [kReleaseMode]-driven so
  /// QA can flip it on in a UAT build without needing a debug binary — but
  /// it must always resolve to `false` in `.env.prod`.
  static bool get isQaDebugToolsEnabled =>
      _getBool('ENABLE_QA_DEBUG_TOOLS', !kReleaseMode);

  /// Retrieves a boolean configuration value with a default fallback.
  ///
  /// [key]: The environment variable key to look up
  /// [defaultValue]: The default value to return if the key is not found or invalid
  ///
  /// Returns `true` if the environment variable is 'true' (case-insensitive),
  /// returns `false` if the environment variable is 'false' (case-insensitive),
  /// otherwise returns [defaultValue] if the key is missing or invalid.
  static bool _getBool(String key, bool defaultValue) {
    try {
      final value = dotenv.maybeGet(key);
      if (value == null) return defaultValue;
      return value.toLowerCase() == 'true';
    } catch (e) {
      developer.log('Failed to parse boolean feature flag for $key: $e');
      return defaultValue;
    }
  }
}
