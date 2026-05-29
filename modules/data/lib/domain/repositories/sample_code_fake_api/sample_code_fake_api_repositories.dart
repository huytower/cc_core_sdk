import 'dart:async';

import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/models/pagination_model.dart';
import '../../../../core/models/pagination_request.dart';
import '../../../../core/repository/cc_base_repository.dart';
import '../../../data/datasource/remote/sample_code_fake_api/sample_code_fake_api_remote.dart';
import '../../entities/sample_code_fake_api/sample_code_fake_entity.dart';

/// [SampleCodeFakeApiRepositories] - Domain Layer Contract
///
/// This interface defines the behaviors required by UseCases.
/// It returns a [Result] type which forces the UI/UseCase to handle both
/// [Success] and [Failure] cases, preventing unexpected crashes.
abstract class SampleCodeFakeApiRepositories {
  /// Get a paginated list of items.
  Future<Result<PaginationModel<SampleCodeFakeEntity>, Failure>>
  getPaginatedList({
    required PaginationRequest paginationRequest,
    Map<String, dynamic>? queryParameters,
  });

  /// Get a single item by ID.
  Future<Result<SampleCodeFakeEntity, Failure>> getById(String id);

  /// Get all items.
  Future<Result<List<SampleCodeFakeEntity>, Failure>> getAll();
}

/// [SampleCodeFakeApiImpl] - Data Layer Implementation
///
/// GUIDELINE FOR DEVELOPERS (Clean Architecture Flow):
///
/// 1. **Horizontal Reuse**: Uses `with CcBaseRepository` to gain access to [safeRequest].
/// 2. **Dependency Injection**: Uses @LazySingleton and @Named('baseDio') for modularity.
/// 3. **Error Handling**:
///    - **Where is error handled?** It is centrally managed in [CcBaseRepository.safeRequest].
///    - **How it works**: [safeRequest] wraps your API call in a try-catch block.
///    - **Mapping**: It automatically converts [DioException] into [NetworkFailure] or [ServerFailure].
/// 4. **Transformation**: Inside [safeRequest], we map Data Models (DTOs) from the Remote
///    DataSource into Domain Entities or Models.
///
/// STEP-BY-STEP IMPLEMENTATION GUIDE:
/// Step 1: Wrap your logic inside `return safeRequest(() async { ... });`.
/// Step 2: Prepare parameters (e.g., merging query params with pagination).
/// Step 3: Call the Remote DataSource method.
/// Step 4: Convert/Map the response into the expected Domain type.
/// Step 5: (Optional) Handle specific business validation (e.g., checking if ID is empty)
///         BEFORE calling [safeRequest].
@LazySingleton(as: SampleCodeFakeApiRepositories)
class SampleCodeFakeApiImpl
    with CcBaseRepository
    implements SampleCodeFakeApiRepositories {
  @factoryMethod
  SampleCodeFakeApiImpl({
    @Named('baseDio') required this.dio,
    required this.remote,
  });

  @override
  final Dio dio;
  final SampleCodeFakeApiRemote remote;

  @override
  Future<Result<PaginationModel<SampleCodeFakeEntity>, Failure>>
  getPaginatedList({
    required PaginationRequest paginationRequest,
    Map<String, dynamic>? queryParameters,
  }) async {
    // [Step 1] Use safeRequest for automatic error handling
    return safeRequest(() async {
      // [Step 2] Prepare parameters
      final params = {...?queryParameters, ...paginationRequest.toJson()};

      // [Step 3] Call Remote DataSource
      final response = await remote.getPaginatedList(params);

      // [Step 4] Map Response DTO to Domain Entity
      final items = (response.data ?? []).map((dto) => dto.toEntity()).toList();

      return PaginationModel<SampleCodeFakeEntity>(
        items: items,
        currentPage: response.currentPage ?? 1,
        itemsPerPage: response.perPage ?? 10,
        totalItems: response.total ?? 0,
      );
    });
  }

  @override
  Future<Result<List<SampleCodeFakeEntity>, Failure>> getAll() async {
    return safeRequest(() async {
      // The interceptor already "peeled" the response.
      // Retrofit returns the List<ResSampleCodeFakeModel> directly.
      final response = await remote.getList();

      // Just map DTOs to Entities
      return response.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<Result<SampleCodeFakeEntity, Failure>> getById(String id) async {
    // [Step 5] Business validation before network call
    if (id.isEmpty) {
      return const Error(DeviceFailure('ID cannot be empty'));
    }

    return safeRequest(() async {
      // The interceptor already "peeled" the response.
      // Retrofit returns the ResSampleCodeFakeModel directly.
      final response = await remote.getObj(id);

      // Just convert DTO to Entity
      return response.toEntity();
    });
  }
}
