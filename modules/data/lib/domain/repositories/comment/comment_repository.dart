import 'dart:async';

import '../../../core/config/retrofit/response/body/cc_res_body_model.dart';
import '../../entities/comment/comment.dart';

abstract class CommentRepository {
  Future<CcResBodyModel<Comment>> getListComments();
}
