import 'dart:developer' as developer;

import 'package:data/domain/entities/comment/comment_entity.dart';
import 'package:data/domain/repositories/comment/comment_repository.dart';
import 'package:get/get.dart';

import '../../../../core/di/di.dart';
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
  final comments = <CommentEntity>[].obs; // List to store comments[]

  @override
  void onReady() {
    super.onReady();

    ccFetchData<CommentEntity>(
      fetchFunction: _commentRepository.getListComments,
      targetList: comments,
    );
    developer.log("CommentController: onReady()", name: "CommentController");
  }
}
