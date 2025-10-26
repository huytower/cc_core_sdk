import 'package:cc_sdk/domain/models/biometric_auth_type.dart';
import 'package:equatable/equatable.dart';

/// Data class representing the persistence model for biometric authentication results.
/// This is a framework-agnostic representation used for data storage and retrieval.
class BiometricAuthResultEntity extends Equatable {
  /// Whether the authentication was successful
  final bool isAuthenticated;
  
  /// Optional error message if authentication failed
  final String? errorMessage;
  
  /// Type of biometric authentication used
  final BiometricAuthType authType;

  /// Creates a new [BiometricAuthResultEntity] instance.
  const BiometricAuthResultEntity({
    required this.isAuthenticated,
    this.errorMessage,
    required this.authType,
  });

  @override
  List<Object?> get props => [isAuthenticated, errorMessage, authType];
}
