import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../config/retrofit/response/body/cc_res_body_model.dart';
import '../../datasource/remote/comment/comment_remote.dart';
import '../../entities/comment/comment.dart';


abstract class CommentRepository {
  Future<CcResBodyModel<Comment>> getListComments();
}

@Singleton(as: CommentRepository)
class CommentRepositoryImpl implements CommentRepository {

  @factoryMethod
  CommentRepositoryImpl({required this.commentRemote});

  final CommentRemote commentRemote;

  @override
  Future<CcResBodyModel<Comment>> getListComments() async {
    /// 1: call api
    final res = await commentRemote.getListComments();

    /// 2: parse data
    return res.flatMapToList((map) => Comment.fromJson(map));
  }
}
