import 'dart:async';

import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../entities/comment/comment_entity.dart';
import '../../../core/models/pagination_request.dart';

abstract class CommentRepository {
  /// Get all comments without pagination (legacy support).
  Future<Result<List<CommentEntity>, Failure>> getListComments();

  /// Get comments with pagination support.
  /// 
  /// Parameters:
  /// - [request]: Pagination request with page and items per page
  /// 
  /// Returns a result containing the list of comments for the requested page.
  Future<Result<List<CommentEntity>, Failure>> getComments(PaginationRequest request);
}