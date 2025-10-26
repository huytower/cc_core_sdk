import 'package:cc_sdk/domain/entities/biometric_auth_result_entity.dart';

abstract class CCSDKLocalDataSource {
  /// Checks if biometric authentication is available on the device
  ///
  /// Throws a [LocalException] if there's an error checking biometric availability
  Future<bool> isBiometricAvailable();

  /// Performs biometric authentication
  ///
  /// Throws a [LocalException] if authentication fails
  Future<BiometricAuthResultEntity> authenticateWithBiometrics({
    required String localizedReason,
    bool useErrorDialogs,
    bool stickyAuth,
  });
}
