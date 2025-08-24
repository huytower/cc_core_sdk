import 'dart:io' show Platform;

import 'package:equatable/equatable.dart';

import '../../../exception/app_config_exception.dart';

/// Base class for application configuration across different environments.
///
/// This abstract class defines the contract that all environment-specific
/// configuration classes must implement. It provides default implementations
/// for common configuration values that can be overridden as needed.
///
/// The class is immutable after instantiation to ensure thread safety and
/// prevent accidental modifications at runtime.
///
/// Example usage:
/// ```dart
/// final config = CcAppConfig.instance;
/// final baseUrl = config.baseUrl;
/// ```
abstract class AppConfigBase extends Equatable {
  /// Creates a new immutable configuration instance.
  const AppConfigBase();

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

  // Immutable configuration - no setters

  @override
  List<Object?> get props => [
        versionIOS,
        versionAndroid,
        versionApi,
        isLogger,
        isEnableLoggerDio,
        baseUrl,
        apiTimeoutSeconds,
        maxRetries,
        retryDelayMs,
        isEnvDev,
        isEnvPro,
      ];

  @override
  bool? get stringify => true;

  // Validation

  /// Validates that all required configuration values are present and valid.
  ///
  /// This method should be called during app initialization to catch
  /// configuration issues early.
  ///
  /// Throws [AppConfigException] if any required configuration is missing or invalid.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   config.validate();
  /// } on AppConfigException catch (e) {
  ///   // Handle configuration error
  /// }
  /// ```
  void validate() {
    // Validate baseUrl
    if (baseUrl.isEmpty) {
      throw const MissingConfigException(key: 'baseUrl');
    }

    // Validate URL format
    if (!baseUrl.startsWith('http')) {
      throw InvalidConfigException(
        key: 'baseUrl',
        value: baseUrl,
        message: 'Must start with http:// or https://',
      );
    }

    // Validate timeouts
    if (apiTimeoutSeconds <= 0) {
      throw InvalidConfigException(
        key: 'apiTimeoutSeconds',
        value: apiTimeoutSeconds,
        message: 'Must be greater than 0',
      );
    }

    // Additional validations for production
    if (isEnvPro && baseUrl.startsWith('http://') && !baseUrl.contains('localhost')) {
      throw const SecurityConfigException(
        message: 'Insecure HTTP protocol detected in production environment',
        key: 'baseUrl',
      );
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
