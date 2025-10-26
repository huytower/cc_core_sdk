import 'package:cc_sdk/domain/models/biometric_auth_type.dart';
import 'package:equatable/equatable.dart';

/// Represents the result of a biometric authentication attempt in the domain layer.
class BiometricAuthResult extends Equatable {
  /// Whether the authentication was successful
  final bool isAuthenticated;
  
  /// Optional error message if authentication failed
  final String? errorMessage;
  
  /// Type of biometric authentication used
  final BiometricAuthType authType;

  const BiometricAuthResult({
    required this.isAuthenticated,
    this.errorMessage,
    required this.authType,
  });

  /// Creates a successful authentication result
  const BiometricAuthResult.success({
    required BiometricAuthType authType,
  })  : isAuthenticated = true,
        errorMessage = null,
        authType = authType;

  /// Creates a failed authentication result
  const BiometricAuthResult.failure({
    required String errorMessage,
    required BiometricAuthType authType,
  })  : isAuthenticated = false,
        errorMessage = errorMessage,
        authType = authType;

  @override
  List<Object?> get props => [isAuthenticated, errorMessage, authType];
}
