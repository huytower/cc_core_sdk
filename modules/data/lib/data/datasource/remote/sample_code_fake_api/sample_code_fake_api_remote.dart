import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/config/retrofit/response/body/cc_res_body_model.dart';
import '../../../../core/models/paginated_response.dart';
import '../../../../domain/entities/sample_code_fake_api/res_sample_code_fake_model.dart';

part 'sample_code_fake_api_remote.g.dart';

@lazySingleton
@RestApi()
abstract class SampleCodeFakeApiRemote {
  @factoryMethod
  factory SampleCodeFakeApiRemote(
    @Named('baseDio') Dio dio, {
    @Named('baseUrl') String? baseUrl,
  }) = _SampleCodeFakeApiRemote;

  /// Get a paginated list of items
  @GET('/api/category/list')
  Future<PaginatedResponse<ResSampleCodeFakeModel>> getPaginatedList(
    @Queries() Map<String, dynamic> params,
  );

  /// Get all items (use with caution for large datasets)
  @GET('/api/category/list')
  Future<List<ResSampleCodeFakeModel>> getList();

  /// Get a single item by ID
  @GET('/api/news/get-id/{id}')
  Future<ResSampleCodeFakeModel> getObj(@Path('id') String id);
}
