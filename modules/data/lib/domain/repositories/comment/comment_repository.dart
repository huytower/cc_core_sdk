import 'dart:async';

import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../entities/comment/comment.dart';

abstract class CommentRepository {
  Future<Result<List<Comment>, Failure>> getListComments();
}
