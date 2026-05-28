import 'package:app_config/core/config/http/http_client/http_client_config.dart';
import 'package:cc_sdk/core/config/cc_feature_flags.dart';
import 'package:cc_sdk/core/extensions/common/cc_logger_extension.dart';
import 'package:cc_sdk/core/extensions/common/cc_when_expression.dart';
import 'package:cc_sdk/core/helper/cc_network_helper.dart';
import 'package:cc_sdk/core/network/curl/curl_utils.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:message/cc_locale_keys.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

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
    @Named("ccReqInterceptor") Interceptor ccReqInterceptor,
    @Named("curlLoggerInterceptor") Interceptor curlLoggerInterceptor,
    @Named("talkerDioLogger") Interceptor talkerDioLogger,
    @Named("cacheInterceptor") Interceptor cacheInterceptor,
  ) {
    return [
      ccReqInterceptor,
      if (CcFeatureFlags.isEnableLoggerDio) curlLoggerInterceptor,
      if (CcFeatureFlags.isEnableLoggerDio) talkerDioLogger,
      cacheInterceptor,
    ];
  }

  @singleton
  @Named("ccReqInterceptor")
  Interceptor ccReqInterceptor(
    InternetConnection internetConnection,
  ) => InterceptorsWrapper(
    onRequest: (options, handler) async {
      /// Check internet connection
      final hasInternet = await CcNetworkHelper(internetConnection).hasInternet;
      if (!hasInternet) {
        final errorMsg = el.tr(CcLocaleKeys.app_error_network);
        errorMsg.Log();
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: errorMsg,
          ),
        );
      }

      'onRequest() : ${options.uri}'.Log();

      /// Handle token logic or specific header cleanup
      /// IMPORTANT: Be careful not to wipe ALL headers unless intended.
      ccWhen(
        conditions: {
          options.headers.containsValue("empty"): () {
            options.headers.removeWhere((key, value) => value == "empty");
          },
          options.headers.containsValue("host_es"): () {
            // Handle specific host logic if needed
          },
        },
      );

      return handler.next(options);
    },
    onResponse: (response, handler) async {
      'onResponse() : status = ${response.statusCode}'.Log();

      if (CcFeatureFlags.isEnableLoggerDio) {
        final curl = await CurlUtils.instance.representation(
          response.requestOptions,
        );
        var url =
            "[Dio Interceptor]\n[Request: ${response.requestOptions.method}] : ${response.requestOptions.uri}\n";
        var _message =
            "$url[Curl]:\n$curl\n[Response: ${response.statusCode}]:\n ${response.data}";

        _message.Log("", true, "logger:###/");
      }

      /// Wrap response data into Map<String, dynamic> if response data is a List
      try {
        if (response.data != null && response.data is List) {
          response.data = wrapListResponse(response.data);
        }
      } catch (e) {
        'Error transforming response data: $e'.Log();
      }
      return handler.next(response);
    },
    onError: (e, handler) {
      'onError() : [${e.response?.statusCode}] $e'.Log();
      return handler.next(e);
    },
  );

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
        // Retry on connection issues or 403
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

  /// Helper method to wrap list response data into a map
  Map<String, dynamic> wrapListResponse(List<dynamic> data) {
    return {
      "status": true,
      "message": el.tr(CcLocaleKeys.home_recent_activity),
      "total": data.length,
      "data": data,
    };
  }
}
