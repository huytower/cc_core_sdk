import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../core/config/retrofit/response/body/cc_res_body_model.dart';
import '../../datasource/remote/comment/comment_remote.dart';
import '../../model/comment/comment_model.dart';
import '../../../domain/entities/comment/comment.dart';
import '../../../domain/repositories/comment/comment_repository.dart';

@Singleton(as: CommentRepository)
class CommentRepositoryImpl implements CommentRepository {
  @factoryMethod
  CommentRepositoryImpl({required this.commentRemote});

  final CommentRemote commentRemote;

  @override
  Future<CcResBodyModel<Comment>> getListComments() async {
    /// 1: call api
    final res = await commentRemote.getListComments();

    /// 2: parse to model and map to entity
    return res.flatMapToList((map) => CommentModel.fromJson(map).toEntity());
  }
}
