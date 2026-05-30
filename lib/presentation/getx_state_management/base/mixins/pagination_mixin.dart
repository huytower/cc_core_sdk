import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:data/core/models/pagination_request.dart';
import 'package:get/get.dart';
import 'package:multiple_result/multiple_result.dart';

import '../structure/getx/cc_get_controller/cc_get_controller.dart';

/// Simple pagination mixin for GetX controllers.
///
/// Usage:
/// ```dart
/// class MyController extends CcGetController with PaginationMixin {
///   final items = <MyEntity>[].obs;
///   
///   Future<void> loadData() {
///     return loadPaginatedData(
///       targetList: items,
///       fetchFunction: (request) => repository.getData(request),
///     );
///   }
/// }
/// ```
mixin PaginationMixin on CcGetController {
  // Pagination state
  final currentPage = 1.obs;
  final itemsPerPage = 20.obs;
  final hasMore = true.obs;
  final isLoading = false.obs;

  /// Get current pagination request
  PaginationRequest get currentRequest => PaginationRequest(
        page: currentPage.value,
        itemsPerPage: itemsPerPage.value,
      );

  /// Initialize pagination
  void initPagination({int initialItemsPerPage = 20}) {
    itemsPerPage.value = initialItemsPerPage;
    currentPage.value = 1;
    hasMore.value = true;
    isLoading.value = false;
  }

  /// Reset pagination state
  void resetPagination() {
    currentPage.value = 1;
    hasMore.value = true;
    isLoading.value = false;
  }

  /// Load paginated data
  Future<void> loadPaginatedData<T>({
    bool refresh = false,
    required RxList<T> targetList,
    required Future<Result<List<T>, Failure>> Function(PaginationRequest)
        fetchFunction,
  }) async {
    if (isLoading.value) return;

    if (refresh) {
      resetPagination();
      targetList.clear();
    }

    if (!hasMore.value && !refresh) return;

    isLoading.value = true;

    try {
      final previousCount = targetList.length;

      await ccFetchData<T>(
        fetchFunction: () => fetchFunction(currentRequest),
        targetList: targetList,
      );

      // Check if we got fewer items than requested
      final newItemsCount = targetList.length - previousCount;
      if (newItemsCount < itemsPerPage.value) {
        hasMore.value = false;
      }

      currentPage.value++;
    } catch (e) {
      hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if can load more data
  bool get canLoadMore => hasMore.value && !isLoading.value;

  /// Get current page number
  int get getCurrentPage => currentPage.value;

  /// Get items per page
  int get getItemsPerPage => itemsPerPage.value;
}