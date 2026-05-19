import 'package:cc_sdk/core/failure/failure.dart';
import 'package:multiple_result/multiple_result.dart';

/// STEP 2: THE REPOSITORY INTERFACE (The "Rules")
/// This is a contract. It says "Anyone who wants to be a CCSDKRepository
/// MUST provide these three functions."
/// It lives in the Domain because it defines business rules.
abstract class CCSDKRepository {
  /// Executes a CURL request
  Future<Result<String, Failure>> executeCurlRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    String method = 'GET',
    bool useProxy = false,
    Duration? timeout,
  });

  /// Converts an object to JSON
  Future<Result<Map<String, dynamic>, Failure>> convertToJson(dynamic object);

  /// Converts JSON back to an object
  Future<Result<T, Failure>> convertFromJson<T>(String jsonString);
}
