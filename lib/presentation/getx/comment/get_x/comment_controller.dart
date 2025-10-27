import 'package:data/domain/entities/comment/comment.dart';
import 'package:data/domain/repositories/comment/comment_repositories.dart';
import 'package:get/get.dart';

import '../../../../core/di/inject/inject.dart';
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
  void onReady() {
    super.onReady();

    ccFetchData<Comment>(
      fetchFunction: _commentRepository.getListComments,
      targetList: comments,
    );
    print("CommentController: onReady()");
  }
}
