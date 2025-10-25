import 'package:meta/meta.dart';

/// Base exception class for configuration-related errors.
///
/// This class provides a structured way to handle configuration errors
/// with detailed information about what went wrong.
@immutable
abstract class AppConfigException implements Exception {
  /// A human-readable error message explaining what went wrong.
  final String message;

  /// The configuration key that caused the error, if applicable.
  final String? key;

  /// The value that caused the error, if applicable.
  final dynamic value;

  /// The type of the exception for programmatic handling.
  final String type;

  /// Creates a new [AppConfigException] instance.
  const AppConfigException({
    required this.message,
    this.key,
    this.value,
    this.type = 'AppConfigException',
  });

  /// Creates a copy of this exception with the given fields replaced.
  AppConfigException copyWith({
    String? message,
    String? key,
    dynamic value,
    StackTrace? stackTrace,
    String? type,
  });

  /// Converts the exception to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'key': key,
      'value': value?.toString(),
    };
  }
}

/// Thrown when a required configuration value is missing.
class MissingConfigException extends AppConfigException {
  /// Creates a new [MissingConfigException] for a missing configuration key.
  const MissingConfigException(
    String key, [
    StackTrace? stackTrace,
  ]) : super(
          message: 'Missing required configuration value',
          key: key,
          type: 'MissingConfigException',
        );

  @override
  MissingConfigException copyWith({
    String? message,
    String? key,
    dynamic value,
    StackTrace? stackTrace,
    String? type,
  }) {
    return MissingConfigException(
      key ?? this.key ?? '',
    ).copyWith(message: message ?? this.message);
  }
}

/// Thrown when a configuration value is invalid.
class InvalidConfigException extends AppConfigException {
  /// Creates a new [InvalidConfigException] for an invalid configuration value.
  const InvalidConfigException({
    required String key,
    dynamic value,
    required String message,
  }) : super(
          message: message,
          key: key,
          value: value,
          type: 'InvalidConfigException',
        );

  @override
  InvalidConfigException copyWith({
    String? message,
    String? key,
    dynamic value,
    StackTrace? stackTrace,
    String? type,
    String? expectedType,
    dynamic actualValue,
  }) {
    return InvalidConfigException(
      key: key ?? this.key ?? '',
      value: value ?? this.value,
      message: message ?? this.message,
    );
  }
}

/// Thrown when there's a security-related configuration issue.
class SecurityConfigException extends AppConfigException {
  /// The security rule or policy that was violated.
  final String? securityRule;

  /// The security level of the exception (e.g., 'warning', 'error', 'critical').
  final String severity;

  /// Creates a new [SecurityConfigException] for security-related issues.
  const SecurityConfigException(
    String message, {
    String? key,
    dynamic value,
    this.securityRule,
    this.severity = 'error',
    StackTrace? stackTrace,
  }) : super(
          message: message,
          key: key,
          value: value,
          type: 'SecurityConfigException',
        );

  @override
  SecurityConfigException copyWith({
    String? message,
    String? key,
    dynamic value,
    StackTrace? stackTrace,
    String? type,
    String? securityRule,
    String? severity,
  }) {
    return SecurityConfigException(
      message ?? this.message,
      key: key ?? this.key,
      value: value ?? this.value,
      securityRule: securityRule ?? this.securityRule,
      severity: severity ?? this.severity,
    );
  }

  /// Creates a security exception for sensitive data exposure.
  factory SecurityConfigException.sensitiveDataExposure({
    required String key,
    required dynamic value,
  }) {
    return SecurityConfigException(
      'Sensitive data exposure detected in configuration',
      key: key,
      value: value,
      securityRule: 'sensitive_data_exposure',
      severity: 'critical',
    );
  }

  /// Creates a security exception for insufficient permissions.
  factory SecurityConfigException.insufficientPermissions({
    required String key,
    required String requiredPermission,
    StackTrace? stackTrace,
  }) {
    return SecurityConfigException(
      'Insufficient permissions to access configuration',
      key: key,
      securityRule: 'insufficient_permissions',
      severity: 'error',
      stackTrace: stackTrace,
    );
  }
}
