import 'package:equatable/equatable.dart';

/// Base class for all failures in the app.
abstract class Failure extends Equatable {
  /// A message describing the failure.
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Failure(message: $message)';
}

/// Failure that occurs when there's a server error.
class ServerFailure extends Failure {
  final int? statusCode;
  final dynamic data;

  const ServerFailure({
    required String message,
    this.statusCode,
    this.data,
  }) : super(message: message);

  @override
  List<Object> get props => [message, statusCode ?? -1];
}

/// Failure that occurs when there's a cache-related error.
class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

/// Failure that occurs when there's a network connectivity issue.
class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

/// Failure that occurs when there's an issue with the device's platform.
class PlatformFailure extends Failure {
  const PlatformFailure({required String message}) : super(message: message);
}

/// Failure that occurs when a required permission is not granted.
class PermissionFailure extends Failure {
  const PermissionFailure({required String message}) : super(message: message);
}

/// Failure that occurs when a feature is not implemented.
class NotImplementedFailure extends Failure {
  const NotImplementedFailure({String message = 'Not implemented'})
      : super(message: message);
}

/// Failure that occurs when a requested resource is not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure({required String message}) : super(message: message);
}

/// Failure that occurs when there's a validation error.
class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure({
    required this.errors,
    String message = 'Validation failed',
  }) : super(message: message);

  @override
  List<Object> get props => [message, errors];
}
