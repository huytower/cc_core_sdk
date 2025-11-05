import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/models/pagination_model.dart';
import '../../../../core/models/pagination_request.dart';
import '../../../data/datasource/remote/sample_code_fake_api/sample_code_fake_api_remote.dart';
import '../../entities/sample_code_fake_api/res_sample_code_fake_model.dart';

abstract class SampleCodeFakeApiRepositories {
  /// Get a paginated list of items
  ///
  /// [paginationRequest] contains pagination parameters
  /// Returns a [PaginationModel] with the paginated results
  Future<PaginationModel<ResSampleCodeFakeModel>> getPaginatedList({
    required PaginationRequest paginationRequest,
    Map<String, dynamic>? queryParameters,
  });

  /// Get a single item by ID
  Future<ResSampleCodeFakeModel> getById(String id);

  /// Get all items (use with caution for large datasets)
  /// Consider using [getPaginatedList] instead for better performance
  Future<List<ResSampleCodeFakeModel>> getAll();
}

@LazySingleton(as: SampleCodeFakeApiRepositories)
class SampleCodeFakeApiImpl implements SampleCodeFakeApiRepositories {
  // final SampleCodeFakeApiRemote remote = SampleCodeFakeApiRemote(dio);

  @factoryMethod
  SampleCodeFakeApiImpl({required this.dio, required this.remote});

  final Dio dio;
  final SampleCodeFakeApiRemote remote;

  /// Free Fake Api End point : https://mockland.dev/api/news/list
  /// ex.
  /// {
  //     "status": true,
  //     "message": "News fetched",
  //     "total": 196,
  //     "data": [
  //         {
  //             "id": "clgsm9c6o00hivkuffqcoo5vo",
  //             "title": "US stocks rise but close lower for the week as investors mull mixed bag of corporate earnings",
  //             "description": "Mega-cap tech companies like Alphabet and Amazon are on deck to report quarterly results next week.",
  //             "content": "Traders work on the floor of the New York Stock ExchangeMichael M. Santiago/Getty Images\r\n<ul>\n<li>
  //             "url": "https://markets.businessinsider.com/news/stocks/stock-market-news-today-dow-sp500-nasdaq-mixed-earnings-reports-2023-4",
  //             "image": "https://i.insider.com/6442e7c5e1a96300185aa30d?width=1200&format=jpeg",
  //             "author": "Morgan Chittum",
  //             "slug": "US-stocks-rise-but-close-lower-for-the-week-as-investors-mull-mixed-bag-of-corporate-earnings",
  //             "memberId": "MAIN",
  //             "publishedAt": "2023-04-21T20:07:23.000Z",
  //             "createdAt": "2023-04-22T23:33:22.919Z",
  //             "updatedAt": "2023-04-22T23:33:22.919Z"
  //         },

  /// Way 1 : Complex way : Auto-parsing way :
  /// convert to Model Object by
  /// wrapping code || combine params to one obj.
  ///
  /// ex.
  /// Iterable l = json.decode(res);
  /// List<Post> posts = List<Post>.from(l.map((model)=> Post.fromJson(model)));
  ///
  @override
  Future<PaginationModel<ResSampleCodeFakeModel>> getPaginatedList({
    required PaginationRequest paginationRequest,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Merge query parameters with pagination parameters
      final params = {
        ...?queryParameters,
        ...paginationRequest.toJson(),
      };

      // Call the API with pagination parameters
      final response = await remote.getPaginatedList(params);

      // Convert the response to a PaginationModel
      return PaginationModel<ResSampleCodeFakeModel>(
        items: response.data ?? [],
        currentPage: response.currentPage ?? 1,
        itemsPerPage: response.perPage ?? 10,
        totalItems: response.total ?? 0,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to load paginated data: $e');
    }
  }

  @override
  Future<List<ResSampleCodeFakeModel>> getAll() async {
    try {
      final response = await remote.getList();
// The response is CcResBodyModel<List<ResSampleCodeFakeModel>>
      // We need to access the actual data list from the response
      return response.firstElement;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Way 2 : Simple way : get data by using params `data` manually
  /// @override
  /// Future<List<SampleCodeFakeModel>> getList() async {
  ///   final map = await remote.getList();
  ///
  ///   final dataObj = map[CcRestApiParams.data.name];
  ///
  ///   return List<SampleCodeFakeModel>.from(dataObj.map((e) => SampleCodeFakeModel.fromJson(e)));
  /// }

  /// Free Fake Api End point : https://mockland.dev/api/news/get-id/{id}
  ///
  /// ex. id = clgslmp1h006rvk5cjip06obz
  ///
  /// {status: {status: true, message: News fetched, code: null},
  /// data:
  /// {id: clgslmp1h006rvk5cjip06obz, title: Quella’s gorgeous retro cafe racer e-bikes are for people who don’t want to
  ///
  @override
  Future<ResSampleCodeFakeModel> getById(String id) async {
    try {
      if (id.isEmpty) {
        throw ArgumentError('ID cannot be empty');
      }

      final response = await remote.getObj(id);
      if (response.firstElement == null) {
        throw Exception('No data found for ID: $id');
      }

      return response.firstElement;
      // return ResSampleCodeFakeModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handles Dio specific errors
  Exception _handleDioError(DioException error) {
    if (error.response != null) {
      // Handle different status codes
      switch (error.response?.statusCode) {
        case 400:
          return Exception('Bad request: ${error.message}');
        case 401:
          return Exception('Unauthorized: Please log in again');
        case 403:
          return Exception('Forbidden: You do not have permission');
        case 404:
          return Exception('Resource not found');
        case 500:
          return Exception('Server error: Please try again later');
        default:
          return Exception(
              'Failed with status code: ${error.response?.statusCode}');
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return Exception(
          'Connection timeout. Please check your internet connection.');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return Exception('Server is taking too long to respond');
    } else if (error.type == DioExceptionType.sendTimeout) {
      return Exception('Request timeout. Please try again.');
    } else {
      return Exception('Network error: ${error.message}');
    }
  }
}
