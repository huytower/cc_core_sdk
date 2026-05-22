import 'package:multiple_result/multiple_result.dart';
import '../entities/cc_device_entity.dart';
import '../failures/cc_failure.dart';

/// Contract defining the core SDK capabilities.
/// Lives in the Domain layer to protect business logic from implementation changes.
abstract class CCSDKRepository {
  /// Fetches structured device information from the local platform.
  Future<Result<CcDeviceEntity, Failure>> getDeviceInfo();

  /// Executes a CURL request.
  Future<Result<String, Failure>> executeCurlRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    String method = 'GET',
    bool useProxy = false,
    Duration? timeout,
  });

  /// Converts an object to JSON.
  Future<Result<Map<String, dynamic>, Failure>> convertToJson(dynamic object);

  /// Converts JSON back to an object.
  Future<Result<T, Failure>> convertFromJson<T>(String jsonString);
}
