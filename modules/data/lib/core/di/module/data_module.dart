import 'package:app_config/core/config/http/http_client/http_client_config.dart';
import 'package:cc_sdk/core/config/cc_feature_flags.dart';
import 'package:cc_sdk/core/extensions/common/cc_logger_extension.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import '../../config/retrofit/interceptors/cc_request_interceptor.dart';
import '../../config/retrofit/interceptors/cc_response_interceptor.dart';

@module
abstract class DataModule {
  //region Register dependency name
  @Named("baseUrl")
  String get baseUrl => HttpClientConfig.baseUrl;

  @lazySingleton
  BaseOptions baseOptions(@Named("baseUrl") String baseUrl) {
    final httpConfig = HttpClientConfig.httpConfig;
    final timeout = Duration(seconds: httpConfig.apiTimeoutSeconds);

    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      headers: HttpClientConfig.apiHeaders,
    );
  }

  @lazySingleton
  @Named("baseDio")
  Dio dio(BaseOptions options, List<Interceptor> interceptors) {
    final dio = Dio(options);

    dio.interceptors.addAll(interceptors);

    // Add retry interceptor separately because it needs the dio instance
    dio.interceptors.add(_retryInterceptor(dio));

    return dio;
  }

  @singleton
  List<Interceptor> interceptors(
    @Named("ccRequestInterceptor") Interceptor ccRequestInterceptor,
    @Named("ccResponseInterceptor") Interceptor ccResponseInterceptor,
    @Named("curlLoggerInterceptor") Interceptor curlLoggerInterceptor,
    @Named("talkerDioLogger") Interceptor talkerDioLogger,
    @Named("cacheInterceptor") Interceptor cacheInterceptor,
  ) {
    return [
      ccRequestInterceptor,
      ccResponseInterceptor,
      if (CcFeatureFlags.isEnableLoggerDio) curlLoggerInterceptor,
      if (CcFeatureFlags.isEnableLoggerDio) talkerDioLogger,
      cacheInterceptor,
    ];
  }

  @singleton
  @Named('ccRequestInterceptor')
  Interceptor get ccRequestInterceptor => CcRequestInterceptor();

  @singleton
  @Named("ccResponseInterceptor")
  Interceptor get ccResponseInterceptor => CcResponseInterceptor();

  // @singleton
  // @Named("ccRequestInterceptor")
  // Interceptor ccRequestInterceptor(InternetConnection internetConnection) =>
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) async {
  //         /// Check internet connection
  //         final hasInternet = await CcNetworkHelper(
  //           internetConnection,
  //         ).hasInternet;
  //         if (!hasInternet) {
  //           final errorMsg = el.tr(CcLocaleKeys.app_error_network);
  //           errorMsg.Log();
  //           return handler.reject(
  //             DioException(
  //               requestOptions: options,
  //               type: DioExceptionType.connectionError,
  //               error: errorMsg,
  //             ),
  //           );
  //         }
  //
  //         'onRequest() : ${options.uri}'.Log();
  //
  //         /// Handle token logic or specific header cleanup
  //         ccWhen(
  //           conditions: {
  //             options.headers.containsValue("empty"): () {
  //               options.headers.removeWhere((key, value) => value == "empty");
  //             },
  //           },
  //         );
  //
  //         return handler.next(options);
  //       },
  //     );

  @singleton
  @Named("curlLoggerInterceptor")
  Interceptor get curlLoggerInterceptor =>
      CurlLoggerDioInterceptor(printOnSuccess: true);

  @singleton
  @Named("talkerDioLogger")
  Interceptor get talkerDioLogger => TalkerDioLogger(
    settings: const TalkerDioLoggerSettings(
      printResponseData: false,
      printRequestData: true,
    ),
  );

  @singleton
  @Named("cacheInterceptor")
  Interceptor get cacheInterceptor {
    final cacheStore = MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576);
    return DioCacheInterceptor(
      options: CacheOptions(
        store: cacheStore,
        allowPostMethod: false,
        policy: CachePolicy.request,
      ),
    );
  }

  /// Helper to configure RetryInterceptor without circularity
  Interceptor _retryInterceptor(Dio dio) {
    final httpConfig = HttpClientConfig.httpConfig;
    return RetryInterceptor(
      dio: dio,
      logPrint: (message) => message.Log("RetryInterceptor"),
      retries: httpConfig.maxRetries,
      retryEvaluator: (e, attempt) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          return true;
        }
        if (e.type == DioExceptionType.badResponse &&
            e.response?.statusCode == 403) {
          return true;
        }
        return false;
      },
      retryDelays: List.generate(
        httpConfig.maxRetries,
        (index) =>
            Duration(milliseconds: httpConfig.retryDelayMs * (index + 1)),
      ),
    );
  }
}
