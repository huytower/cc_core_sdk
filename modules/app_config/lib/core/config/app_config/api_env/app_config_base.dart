import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Base class for application configuration across different environments.
///
/// This abstract class defines the contract that all environment-specific
/// configuration classes must implement. It provides default implementations
/// for common configuration values that can be overridden as needed.
///
/// Example usage:
/// ```dart
/// final config = CcAppConfig.instance;
/// final baseUrl = config.baseUrl;
/// ```
abstract class AppConfigBase {
  // Version Information

  /// The current iOS app version.
  ///
  /// This should be incremented with each App Store release.
  int get versionIOS => 1;

  /// The current Android app version code.
  ///
  /// This should be incremented with each Play Store release.
  int get versionAndroid => 1;

  /// The current API version.
  ///
  /// This should match the expected API version on the server.
  int get versionApi => 0;

  // Logging Configuration

  /// Whether general application logging is enabled.
  ///
  /// When `true`, application-level logs should be recorded.
  bool get isLogger;

  /// Whether Dio HTTP client logging is enabled.
  ///
  /// When `true`, HTTP request/response logging will be enabled.
  bool get isEnableLoggerDio;

  // API Configuration

  /// The base URL for all API requests.
  ///
  /// This should include the protocol (http/https) and domain,
  /// but no trailing slash.
  /// Example: 'https://api.example.com/v1'
  String get baseUrl;

  /// Timeout duration for API requests in seconds.
  ///
  /// Defaults to 30 seconds.
  int get apiTimeoutSeconds => 30;

  /// Maximum number of retry attempts for failed API requests.
  ///
  /// Set to 0 to disable retries.
  int get maxRetries => 2;

  /// Delay between retry attempts in milliseconds.
  ///
  /// This is the initial delay, which may be increased with exponential backoff.
  int get retryDelayMs => 1000;

  // Environment Flags

  /// Whether the current environment is development.
  ///
  /// Should be `true` only in development environments.
  bool get isEnvDev => false;

  /// Whether the current environment is production.
  ///
  /// Should be `true` only in production environments.
  bool get isEnvPro => false;

  // Setters

  /// Updates the logging configuration.
  ///
  /// [value] - The new logging enabled state
  set isLogger(bool value) {
    if (kDebugMode) {
      developer.log('Logging ${value ? 'enabled' : 'disabled'}');
    }
  }

  /// Updates the Dio logging configuration.
  ///
  /// [value] - The new Dio logging enabled state
  set isEnableLoggerDio(bool value) {
    if (kDebugMode) {
      developer.log('Dio logging ${value ? 'enabled' : 'disabled'}');
    }
  }

  // Validation

  /// Validates that all required configuration values are present and valid.
  ///
  /// This method should be called during app initialization to catch
  /// configuration issues early.
  ///
  /// Throws [StateError] if any required configuration is missing or invalid.
  void validate() {
    if (baseUrl.isEmpty) {
      throw StateError('baseUrl must be configured');
    }

    if (!baseUrl.startsWith('http')) {
      throw StateError('baseUrl must start with http:// or https://');
    }

    if (apiTimeoutSeconds <= 0) {
      throw StateError('apiTimeoutSeconds must be greater than 0');
    }
  }

  // Headers

  /// Returns the default headers for all API requests.
  ///
  /// These headers will be included with every API request unless overridden.
  ///
  /// Returns [Map<String, String>] of default headers
  Map<String, String> get apiHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-App-Version': versionApi.toString(),
        'X-Platform': '${Platform.isAndroid ? 'Android' : 'iOS'}-${Platform.operatingSystemVersion}',
      };

  @override
  String toString() => 'AppConfigBase('
      'versionIOS: $versionIOS, '
      'versionAndroid: $versionAndroid, '
      'versionApi: $versionApi, '
      'baseUrl: $baseUrl, '
      'isLogger: $isLogger, '
      'isEnableLoggerDio: $isEnableLoggerDio'
      ')';
}
