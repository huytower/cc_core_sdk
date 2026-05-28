import 'dart:async';

import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../core/repository/cc_base_repository.dart';
import '../../../domain/entities/comment/comment.dart';
import '../../../domain/repositories/comment/comment_repository.dart';
import '../../datasource/remote/comment/comment_remote.dart';
import '../../model/comment/comment_model.dart';

@Singleton(as: CommentRepository)
class CommentRepositoryImpl with CcBaseRepository implements CommentRepository {
  @factoryMethod
  CommentRepositoryImpl({required this.commentRemote});

  final CommentRemote commentRemote;

  @override
  Future<Result<List<Comment>, Failure>> getListComments() async {
    return safeRequest(() async {
      final res = await commentRemote.getListComments();
      final comments = res.flatMapToList(
        (map) => CommentModel.fromJson(map).toEntity(),
      );
      return comments.listElements;
    });
  }
}
