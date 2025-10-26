import 'package:cc_sdk/core/exception/error/failure.dart';
import 'package:cc_sdk/domain/models/biometric_auth_result.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class CCSDKRepository {
  // Biometric Authentication
  Future<Result<bool, Failure>> isBiometricAvailable();
  Future<Result<BiometricAuthResult, Failure>> authenticateWithBiometrics({
    required String localizedReason,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  });

  // CURL Operations
  Future<Result<String, Failure>> executeCurlRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    String method = 'GET',
    bool useProxy = false,
    Duration? timeout,
  });

  // GSON Operations
  Future<Result<Map<String, dynamic>, Failure>> convertToJson(dynamic object);
  Future<Result<T, Failure>> convertFromJson<T>(String jsonString);
}
