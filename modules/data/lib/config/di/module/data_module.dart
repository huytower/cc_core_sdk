import 'package:app_config/config/app_config/cc_app_config.dart';
import 'package:app_config/helper/network_helper.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
// import 'package:data/datasource/local/home/home_database.dart';
// import 'package:data/datasource/local/setting/setting_database.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:widget/export/cc_ktx_export.dart';

@module
abstract class DataModule {
  // @preResolve
  // Future<HomeDatabase> get homeDatabase async {
  //   return $FloorHomeDatabase.databaseBuilder('home_database.db').build();
  // }

  // @preResolve
  // Future<SettingDatabase> get settingDatabase async {
  //   return $FloorSettingDatabase.databaseBuilder('setting_database.db').build();
  // }

  //region Register dependency name
  @Named("baseUrl")
  String get baseUrl => CcAppHostUrlName.baseUrl;

  @Named("baseUrlOther")
  String get baseUrlOther => CcAppHostUrlName.baseUrlOther;

  @singleton
  @Named("baseDio")
  Dio dio(@Named("baseUrl") String baseUrl) {
    var _dio = Dio(
      BaseOptions(
        /// baseUrl: NOT DEFINE HERE, FOLLOW RETROFIT ANNOTATION
        baseUrl: baseUrl,

        /// Set default timeout for retrofit.
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 40),
        sendTimeout: const Duration(seconds: 40),
      ),
    );

    _dio.interceptors.addAll(ccInterceptors);

    return _dio;
  }
// Dio dio = ccDio();

  // Interceptors
  @singleton
  Iterable<Interceptor> get ccInterceptors {
    final loggerCurl = CurlLoggerDioInterceptor(printOnSuccess: true);
    final loggerTalker = TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printResponseData: false,
        printRequestData: true,
      ),
    );

    final cacheStore = MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576);
    final cache = DioCacheInterceptor(
      options: CacheOptions(store: cacheStore, hitCacheOnErrorCodes: []),
    );

    return [ccReqInterceptors, loggerCurl, loggerTalker, cache];
  }

  @singleton
  Interceptor get ccReqInterceptors => InterceptorsWrapper(
    onRequest: (options, handler) async {
      /// Check internet connection
      final hasInternet = await NetworkHelper(InternetConnectionChecker.createInstance()).hasInternet;
      if (!hasInternet) {
        'No internet connection'.Log();
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: 'No internet connection',
          ),
        );
      }

      'onRequest() '.Log();

      /// handle token invalid :
      /// call app get token.
      when(
        conditions: {
          options.headers.containsValue("empty"): () {
            options.headers = {};
          },
          options.headers.containsValue("host_es"): () {
            options.headers = {};
          }
        },
        orElse: () {
          options.headers = {};
        },
      );
      return handler.next(options);
    },
    onResponse: (response, handler) async {
      'onResponse() : response = $response'.Log();

      /// Wrap response data into Map<String, dynamic> if response data is a List
      try {
        if (response.data != null && response.data is List) {
          response.data = wrapListResponse(response.data);
        }
      } catch (e) {
        print('Error transforming response data: $e');
      }
      return handler.next(response);
    },
    onError: (e, handler) {
      'onError() : $e'.Log();

      return handler.next(e);
    },
  );

  /// Helper method to wrap list response data into a map
  Map<String, dynamic> wrapListResponse(List<dynamic> data) {
    return {
      "status": true,
      "message": "Data fetched successfully",
      "total": data.length,
      "data": data,
    };
  }
}
