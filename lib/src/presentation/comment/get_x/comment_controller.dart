import 'package:app_config/enum/layout_status.dart';
import 'package:cc_library/extension/logger.dart';
import 'package:data/entities/comment/comment.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:data/repositories/comment/comment_repositories.dart';
import 'package:injectable/injectable.dart';

import '../../../core/extension/app_tracking_log_extension.dart';
import '../../base/structure/getx/cc_get_controller/cc_get_controller.dart';

@injectable
class CommentController extends CcGetController {
  CommentController(this._commentRepository);

  final CommentRepository _commentRepository;
  final comments = <Comment>[].obs; // List to store comments[]

  @override
  void onInit() {
    super.onInit();

    initData();
  }

  Future<void> initData() async {
    layoutStatus.value = LayoutStatus.loading;
    '🔄 Fetching comments started'.Log().addAppTrackingLog();
    try {
      final fetchedComments = await _commentRepository.getListComments();
      comments.assignAll(fetchedComments);
      layoutStatus.value = LayoutStatus.success;
    } on DioException catch (dioError) {
      layoutStatus.value = LayoutStatus.error;

      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.sendTimeout ||
          dioError.type == DioExceptionType.receiveTimeout) {
        '⏰ Timeout error occurred: ${dioError.message}'.Log().addAppTrackingLog();
      } else {
        '❌ Dio error occurred: ${dioError.message}'.Log().addAppTrackingLog();
      }
    } catch (e) {
      layoutStatus.value = LayoutStatus.error;
      '❗ Unknown error: $e'.Log().addAppTrackingLog();
    }
  }
}