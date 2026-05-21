import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/comment/comment.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  CommentModel({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  Comment toEntity() =>
      Comment(postId: postId, id: id, name: name, email: email, body: body);
}
