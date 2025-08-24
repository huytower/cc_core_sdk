/// Base exception class for configuration-related errors.
abstract class AppConfigException implements Exception {
  final String message;
  final String? key;
  final dynamic value;
  final StackTrace? stackTrace;

  const AppConfigException(
    this.message, {
    this.key,
    this.value,
    this.stackTrace,
  });

  @override
  String toString() => 'AppConfigException: $message\n'
      'Key: $key\n'
      'Value: $value\n'
      '${stackTrace ?? ''}';
}

/// Thrown when a required configuration value is missing.
class MissingConfigException extends AppConfigException {
  const MissingConfigException({
    required String key,
    StackTrace? stackTrace,
  }) : super(
          'Required configuration value is missing',
          key: key,
          stackTrace: stackTrace,
        );
}

/// Thrown when a configuration value is invalid.
class InvalidConfigException extends AppConfigException {
  const InvalidConfigException({
    required String key,
    required dynamic value,
    String? message,
    StackTrace? stackTrace,
  }) : super(
          message ?? 'Invalid configuration value',
          key: key,
          value: value,
          stackTrace: stackTrace,
        );
}

/// Thrown when there's a security-related configuration issue.
class SecurityConfigException extends AppConfigException {
  const SecurityConfigException({
    required String message,
    String? key,
    dynamic value,
    StackTrace? stackTrace,
  }) : super(
          'Security violation: $message',
          key: key,
          value: value,
          stackTrace: stackTrace,
        );
}
