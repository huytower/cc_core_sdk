import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../model/comment/comment_model.dart';

part 'comment_remote.g.dart';

@singleton
@RestApi()
abstract class CommentRemote {
  @factoryMethod
  factory CommentRemote(@Named('baseDio') Dio dio) = _CommentRemote;

  /// Get all comments.
  /// The CcResponseInterceptor handles peeling the envelope.
  @GET('/comments')
  Future<List<CommentModel>> getListComments();
}
