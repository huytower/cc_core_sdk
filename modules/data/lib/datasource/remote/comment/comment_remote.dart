import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../entities/comment/comment.dart';

part 'comment_remote.g.dart';

@singleton
@RestApi()
abstract class CommentRemote {
  @factoryMethod
  factory CommentRemote(@Named('commentDio') Dio dio) = _CommentRemote;

  @GET('/comments')
  Future<List<Comment>> getListComments();
}
