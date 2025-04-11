import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../datasource/remote/comment/comment_remote.dart';
import '../../entities/comment/comment.dart';


abstract class CommentRepository {
  Future<List<Comment>> getListComments();
}

@Singleton(as: CommentRepository)
class CommentRepositoryImpl implements CommentRepository {

  @factoryMethod
  CommentRepositoryImpl({required this.commentRemote});

  final CommentRemote commentRemote;

  @override
  Future<List<Comment>> getListComments() => commentRemote.getListComments();
}
