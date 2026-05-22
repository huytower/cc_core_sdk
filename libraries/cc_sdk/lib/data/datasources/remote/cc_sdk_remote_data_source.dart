import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

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

@LazySingleton(as: CCSDKRemoteDataSource)
class CCSDKRemoteDataSourceImpl implements CCSDKRemoteDataSource {
  final Dio dio;

  const CCSDKRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> executeCurlRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    required String method,
    bool useProxy = false,
    Duration? timeout,
  }) async {
    try {
      final response = await dio.request(
        url,
        options: Options(
          method: method,
          headers: headers,
        ),
        data: body,
      );
      return jsonEncode(response.data);
    } on DioException catch (e) {
      throw HttpException(e.message ?? 'Network error');
    }
  }
}
