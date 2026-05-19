/// STEP 4: THE DATA SOURCE (The "Laborer")
/// This is the lowest level. It talks directly to the server.
/// It doesn't return "Failures", it throws "Exceptions".
abstract class CCSDKRemoteDataSource {
  /// Actually performs the HTTP/CURL call to the internet.
  Future<String> executeCurlRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    required String method,
    bool useProxy,
    Duration? timeout,
  });
}
