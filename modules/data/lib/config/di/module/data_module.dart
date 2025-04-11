import 'dart:developer';

import 'package:app_config/config/app_config/cc_app_config.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
// import 'package:data/datasource/local/home/home_database.dart';
// import 'package:data/datasource/local/setting/setting_database.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:widget/export/cc_ktx_export.dart';

import '../../interceptor/cc_interceptor.dart';

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

  @Named("commentUrl")
  String get commentUrl => CcAppHostUrlName.commentUrl;

  @singleton
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
  @lazySingleton
  Iterable<Interceptor> get ccInterceptors {
    final loggerCurl = CurlLoggerDioInterceptor(printOnSuccess: true);
    final loggerTalker = TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(printResponseData: true),
    );

    final cacheStore = MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576);
    final cache = DioCacheInterceptor(
      options: CacheOptions(store: cacheStore, hitCacheOnErrorCodes: []),
    );

    return [loggerCurl, loggerTalker, cache];
  }

  @singleton
  @Named("commentDio")
  Dio commentDio(
      @Named("commentUrl") String baseUrl,
      Iterable<Interceptor> ccInterceptors,
  ) {
    final _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl, // Specific for comment API
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 40),
        sendTimeout: const Duration(seconds: 40),
      ),
    );

    // Custom manual interceptor for logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          "\uD83D\uDD03 [Dio Request] \${options.method} \${options.uri}".Log();
          return handler.next(options);
        },
        onResponse: (response, handler) {
          "✅ [Dio Response] \${response.statusCode} \${response.requestOptions.uri}".Log();
          return handler.next(response);
        },
        onError: (e, handler) {
          "❌ [Dio Error] \${e.type} | \${e.message}".Log();
          return handler.next(e);
        },
      ),
    );

    _dio.interceptors.addAll(ccInterceptors);

    return _dio;
  }

}
