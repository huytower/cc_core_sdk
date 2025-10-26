import 'package:meta/meta.dart';

import 'error/failure.dart';

/// Base exception class for configuration-related errors.
///
/// This class extends [Failure] to provide a structured way to handle
/// configuration errors with detailed information about what went wrong.
@immutable
abstract class AppConfigException extends Failure {
  /// The configuration key that caused the error, if applicable.
  final String? key;

  /// The type of the exception for programmatic handling.
  final String type;

  /// Creates a new [AppConfigException] instance.
  const AppConfigException(
    String message, {
    this.key,
    this.type = 'AppConfigException',
  }) : super(message);

  @override
  List<Object?> get props => [message, key, type];

  /// Creates a copy of this exception with the given fields replaced.
  AppConfigException copyWith({
    String? message,
    String? key,
    String type = 'AppConfigException',
  }) {
    throw UnimplementedError('copyWith must be implemented by subclasses');
  }

  /// Converts the exception to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'key': key,
    };
  }
}

/// Failure specific to configuration operations.
class ConfigFailure extends Failure {
  const ConfigFailure(String message) : super(message);
}

/// Thrown when a required configuration value is missing.
class MissingConfigException extends AppConfigException {
  /// Creates a new [MissingConfigException] for a missing configuration key.
  const MissingConfigException(
    String key, {
    String? message,
    String type = 'MissingConfigException',
  }) : super(
          message ?? 'Missing required configuration: $key',
          key: key,
          type: type,
        );

  @override
  MissingConfigException copyWith({
    String? message,
    String? key,
    String type = 'MissingConfigException',
  }) {
    return MissingConfigException(
      key ?? this.key ?? '',
      message: message,
      type: type,
    );
  }
}

/// Thrown when there's a security-related configuration issue.
class SecurityConfigException extends AppConfigException {
  /// The security rule that was violated.
  final String securityRule;

  /// The severity level of the security issue.
  final String severity;

  /// Creates a new [SecurityConfigException] for a security-related configuration issue.
  const SecurityConfigException(
    String message, {
    required String key,
    required this.securityRule,
    this.severity = 'high',
  }) : super(
          message,
          key: key,
          type: 'SecurityConfigException',
        );

  @override
  List<Object?> get props => [...super.props, securityRule, severity];

  @override
  SecurityConfigException copyWith({
    String? message,
    String? key,
    String? type,
    String? securityRule,
    String? severity,
  }) {
    return SecurityConfigException(
      message ?? this.message,
      key: key ?? this.key ?? '',
      securityRule: securityRule ?? this.securityRule,
      severity: severity ?? this.severity,
    );
  }

  /// Creates a security exception for sensitive data exposure.
  factory SecurityConfigException.sensitiveDataExposure({
    required String key,
    String? message,
  }) {
    return SecurityConfigException(
      message ?? 'Sensitive data exposure detected in configuration',
      key: key,
      securityRule: 'sensitive_data_exposure',
      severity: 'critical',
    );
  }

  /// Creates a security exception for insufficient permissions.
  factory SecurityConfigException.insufficientPermissions({
    required String key,
    required String requiredPermission,
  }) {
    return SecurityConfigException(
      'Insufficient permissions to access configuration. Required: $requiredPermission',
      key: key,
      securityRule: 'insufficient_permissions',
      severity: 'error',
    );
  }
}
