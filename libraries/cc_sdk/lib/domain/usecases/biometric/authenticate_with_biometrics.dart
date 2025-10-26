import 'package:cc_sdk/core/exception/error/failure.dart';
import 'package:cc_sdk/domain/models/biometric_auth_result.dart';
import 'package:cc_sdk/domain/repositories/cc_sdk_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class AuthenticateWithBiometricsParams {
  final String localizedReason;
  final bool useErrorDialogs;
  final bool stickyAuth;

  const AuthenticateWithBiometricsParams({
    required this.localizedReason,
    this.useErrorDialogs = true,
    this.stickyAuth = false,
  });
}

class AuthenticateWithBiometrics {
  final CCSDKRepository repository;

  const AuthenticateWithBiometrics(this.repository);

  Future<Result<BiometricAuthResult, Failure>> call(
      AuthenticateWithBiometricsParams params) async {
    try {
      final result = await repository.authenticateWithBiometrics(
        localizedReason: params.localizedReason,
        useErrorDialogs: params.useErrorDialogs,
        stickyAuth: params.stickyAuth,
      );
      return result;
    } catch (e) {
      return Error(BiometricFailure(e.toString()));
    }
  }
}
