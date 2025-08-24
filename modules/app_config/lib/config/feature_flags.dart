import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Manages feature flags for the application.
///
/// Feature flags can be controlled via environment variables or have default values
/// based on the current environment.
///
/// Example usage:
/// ```dart
/// if (FeatureFlags.isEnableLogger) {
///   // Enable logging
/// }
/// ```
class FeatureFlags {
  // Private constructor to prevent instantiation
  FeatureFlags._();

  /// Whether logging is enabled
  static bool get isEnableLogger => _getBool('ENABLE_LOGGER', !kReleaseMode);

  /// Whether Dio HTTP client logging is enabled
  static bool get isEnableLoggerDio => _getBool('ENABLE_LOGGER_DIO', !kReleaseMode);

  /// Whether analytics is enabled
  static bool get isAnalyticsEnabled => _getBool('ANALYTICS_ENABLED', true);

  /// Whether crash reporting is enabled
  static bool get isCrashReportingEnabled => _getBool('CRASH_REPORTING_ENABLED', true);

  /// Retrieves a boolean configuration value with a default fallback.
  ///
  /// [key]: The environment variable key to look up
  /// [defaultValue]: The default value to return if the key is not found or invalid
  ///
  /// Returns `true` if the environment variable is 'true' (case-insensitive),
  /// otherwise returns [defaultValue].
  static bool _getBool(String key, bool defaultValue) {
    try {
      final value = dotenv.maybeGet(key)?.toLowerCase();
      return value == 'true';
    } catch (e) {
      return defaultValue;
    }
  }
}
