import 'dart:async';

import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../core/repository/cc_base_repository.dart';
import '../../../domain/entities/comment/comment_entity.dart';
import '../../../domain/repositories/comment/comment_repository.dart';
import '../../datasource/remote/comment/comment_remote.dart';

@Singleton(as: CommentRepository)
class CommentRepositoryImpl with CcBaseRepository implements CommentRepository {
  @factoryMethod
  CommentRepositoryImpl({required this.commentRemote});

  final CommentRemote commentRemote;

  @override
  Future<Result<List<CommentEntity>, Failure>> getListComments() async {
    return safeRequest(() async {
      // 1. Call the remote source (The interceptor already peeled the JSON)
      final response = await commentRemote.getListComments();

      // 2. Map DTOs to Entities
      return response.map((model) => model.toEntity()).toList();
    });
  }
}
