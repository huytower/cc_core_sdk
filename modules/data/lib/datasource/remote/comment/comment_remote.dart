import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../config/retrofit/response/body/cc_res_body_model.dart';
import '../../../entities/comment/comment.dart';

part 'comment_remote.g.dart';

@singleton
@RestApi()
abstract class CommentRemote {
  @factoryMethod
  factory CommentRemote(@Named('baseDio') Dio dio) = _CommentRemote;

  @GET('/comments')
  Future<CcResBodyModel<Comment>> getListComments();
}
