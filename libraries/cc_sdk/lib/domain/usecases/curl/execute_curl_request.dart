import '../../failures/cc_failure.dart';
import '../../repositories/cc_sdk_repository.dart';
import '../usecase.dart';
import 'package:multiple_result/multiple_result.dart';

class ExecuteCurlRequestParams {
  final String url;
  final Map<String, String>? headers;
  final dynamic body;
  final String method;
  final bool useProxy;
  final Duration? timeout;

  const ExecuteCurlRequestParams({
    required this.url,
    this.headers,
    this.body,
    this.method = 'GET',
    this.useProxy = false,
    this.timeout,
  });
}

/// STEP 1: THE USECASE (The "Boss")
/// This class represents a single task the app can do.
/// It doesn't know HOW to use the internet, it just says "Execute this task".
class ExecuteCurlRequest implements UseCase<String, ExecuteCurlRequestParams> {
  // The UseCase holds a reference to the Interface (the rules), not the implementation.
  final CCSDKRepository repository;

  const ExecuteCurlRequest(this.repository);

  @override
  Future<Result<String, Failure>> call(ExecuteCurlRequestParams params) async {
    // We simply pass the request down the chain.
    return await repository.executeCurlRequest(
      url: params.url,
      headers: params.headers,
      body: params.body,
      method: params.method,
      useProxy: params.useProxy,
      timeout: params.timeout,
    );
  }
}
