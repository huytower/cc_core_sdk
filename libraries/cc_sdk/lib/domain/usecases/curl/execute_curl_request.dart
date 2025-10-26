import 'package:cc_sdk/core/exception/error/failure.dart';
import 'package:cc_sdk/domain/repositories/cc_sdk_repository.dart';
import 'package:cc_sdk/domain/usecases/usecase.dart';
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

class ExecuteCurlRequest implements UseCase<String, ExecuteCurlRequestParams> {
  final CCSDKRepository repository;

  const ExecuteCurlRequest(this.repository);

  @override
  Future<Result<String, Failure>> call(ExecuteCurlRequestParams params) async {
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
