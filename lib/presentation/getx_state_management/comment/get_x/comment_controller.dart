import 'package:data/domain/entities/comment/comment_entity.dart';
import 'package:data/domain/repositories/comment/comment_repository.dart';
import 'package:get/get.dart';

import '../../../../core/di/di.dart';
import '../../base/mixins/pagination_mixin.dart';
import '../../base/structure/getx/cc_get_controller/cc_get_controller.dart';

class CommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => getIt<CommentController>());
  }
}

class CommentController extends CcGetController with PaginationMixin {
  CommentController(this._commentRepository);

  final CommentRepository _commentRepository;

  // List to store comments
  final comments = <CommentEntity>[].obs;

  @override
  void onReady() {
    super.onReady();

    // Initialize pagination
    initPagination();
    
    // Load first page of comments
    loadComments();
  }

  /// Load comments for the current page
  Future<void> loadComments({bool refresh = false}) async {
    await loadPaginatedData<CommentEntity>(
      refresh: refresh,
      targetList: comments,
      fetchFunction: (request) => _commentRepository.getComments(request),
    );
  }

  /// Load next page of comments
  Future<void> loadNextPageComments() {
    return loadPaginatedData<CommentEntity>(
      targetList: comments,
      fetchFunction: (request) => _commentRepository.getComments(request),
    );
  }

  /// Refresh comments from first page
  Future<void> refresh() {
    return loadPaginatedData<CommentEntity>(
      refresh: true,
      targetList: comments,
      fetchFunction: (request) => _commentRepository.getComments(request),
    );
  }
}