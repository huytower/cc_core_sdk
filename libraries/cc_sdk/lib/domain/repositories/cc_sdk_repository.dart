import 'package:cc_sdk/core/exception/error/failure.dart';
import 'package:multiple_result/multiple_result.dart';

/// Repository interface for CURL and GSON operations
abstract class CCSDKRepository {
  /// Executes a CURL request with the given parameters
  Future<Result<String, Failure>> executeCurlRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    String method = 'GET',
    bool useProxy = false,
    Duration? timeout,
  });

  /// Converts an object to JSON format
  Future<Result<Map<String, dynamic>, Failure>> convertToJson(dynamic object);

  /// Converts a JSON string to a strongly-typed object
  Future<Result<T, Failure>> convertFromJson<T>(String jsonString);
}
