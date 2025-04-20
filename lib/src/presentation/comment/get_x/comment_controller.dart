import 'package:app_config/enum/layout_status.dart';
import 'package:data/entities/comment/comment.dart';
import 'package:data/repositories/comment/comment_repositories.dart';
import 'package:get/get.dart';

import '../../../core/di/inject/app_inject.dart';
import '../../base/structure/getx/cc_get_controller/cc_get_controller.dart';

class CommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => getIt<CommentController>());
  }
}

class CommentController extends CcGetController {
  CommentController(this._commentRepository);

  final CommentRepository _commentRepository;
  final comments = <Comment>[].obs; // List to store comments[]

  @override
  void onInit() {
    super.onInit();

    fetchData<Comment>(
      fetchFunction: _commentRepository.getListComments,
      targetList: comments,
      layoutStatus: layoutStatus,
      errorMessage: errorMessage,
    );
    print("CommentController: onInit()");

    loadAllComments();
  }

  Future<void> loadAllComments() async {
    layoutStatus.value = LayoutStatus.loading;
    try {
      final fetchedComments = await _commentRepository.getListComments();
      comments.assignAll(fetchedComments);
      layoutStatus.value = LayoutStatus.success;
    } catch (e) {
      layoutStatus.value = LayoutStatus.error;
    }
  }
}
