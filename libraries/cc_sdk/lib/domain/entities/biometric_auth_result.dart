import 'package:equatable/equatable.dart';

class BiometricAuthResult extends Equatable {
  final bool isAuthenticated;
  final String? errorMessage;
  final BiometricAuthType authType;

  const BiometricAuthResult({
    required this.isAuthenticated,
    this.errorMessage,
    required this.authType,
  });

  @override
  List<Object?> get props => [isAuthenticated, errorMessage, authType];
}

enum BiometricAuthType {
  faceId,
  fingerprint,
  face,
  none,
}
