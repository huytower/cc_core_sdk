import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:dio/dio.dart';
import 'package:multiple_result/multiple_result.dart';

/// Mixin for repositories to handle common logic like error mapping.
///
/// Using a mixin allows repository implementations to share this logic
/// without using up their single inheritance slot.
mixin CcBaseRepository {
  /// Executes a network request and maps any DioException to a Failure.
  Future<Result<T, Failure>> safeRequest<T>(
    Future<T> Function() request,
  ) async {
    try {
      final response = await request();
      return Success(response);
    } on DioException catch (e) {
      return Error(mapDioErrorToFailure(e));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }

  /// Maps DioException to standardized Failure types.
  Failure mapDioErrorToFailure(DioException error) {
    final message = error.message ?? 'Unknown error occurred';
    final statusCode = error.response?.statusCode;

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return NetworkFailure(message);
    }

    if (error.response != null) {
      return ServerFailure('Server error: $message', statusCode: statusCode);
    }

    return ServerFailure(message);
  }
}
