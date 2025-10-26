abstract class CCSDKRemoteDataSource {
  /// Executes a CURL request with the given parameters
  ///
  /// Throws a [ServerException] for all error codes.
  Future<String> executeCurlRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    required String method,
    bool useProxy,
    Duration? timeout,
  });
}
