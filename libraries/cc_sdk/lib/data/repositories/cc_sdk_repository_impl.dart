import 'dart:convert';
import 'dart:io';

import 'package:cc_sdk/core/exception/error/failure.dart';
import 'package:cc_sdk/core/network/network_info.dart';
import 'package:cc_sdk/data/datasources/remote/cc_sdk_remote_data_source.dart';
import 'package:cc_sdk/domain/repositories/cc_sdk_repository.dart';
import 'package:multiple_result/multiple_result.dart';

/// Implementation of [CCSDKRepository] handling CURL and GSON operations
class CCSDKRepositoryImpl implements CCSDKRepository {
  final CCSDKRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  /// Creates a new instance of [CCSDKRepositoryImpl]
  const CCSDKRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<String, Failure>> executeCurlRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    String method = 'GET',
    bool useProxy = false,
    Duration? timeout,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Error(NetworkFailure('No internet connection'));
    }

    try {
      final response = await remoteDataSource.executeCurlRequest(
        url: url,
        headers: headers,
        body: body,
        method: method,
        useProxy: useProxy,
        timeout: timeout,
      );
      return Success(response);
    } on HttpException catch (e) {
      return Error(ServerFailure(e.message));
    } on FormatException {
      return const Error(CurlFailure('Invalid response format'));
    } catch (e) {
      return Error(CurlFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Failure>> convertToJson(
      dynamic object) async {
    try {
      final jsonString = json.encode(object);
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return Success(jsonMap);
    } on FormatException catch (e) {
      return Error(
          CacheFailure('Failed to convert object to JSON: ${e.message}'));
    }
  }

  @override
  Future<Result<T, Failure>> convertFromJson<T>(String jsonString) async {
    try {
      final jsonMap = json.decode(jsonString);
      return Success(jsonMap as T);
    } on FormatException catch (e) {
      return Error(CacheFailure('Failed to parse JSON string: ${e.message}'));
    } on TypeError catch (e) {
      return Error(CacheFailure('Type mismatch: $e'));
    } catch (e) {
      return Error(CacheFailure('Unexpected error: $e'));
    }
  }
}
