import 'dart:async';

import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../entities/comment/comment_entity.dart';

abstract class CommentRepository {
  Future<Result<List<CommentEntity>, Failure>> getListComments();
}
