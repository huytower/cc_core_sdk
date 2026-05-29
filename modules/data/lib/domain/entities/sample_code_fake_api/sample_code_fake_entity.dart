import 'package:equatable/equatable.dart';

/// Pure Domain Entity for Sample Code.
/// No JSON annotations, no dependencies on Data Layer.
class SampleCodeFakeEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String content;
  final String url;
  final String image;
  final String author;
  final String name;
  final String slug;
  final String memberId;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;

  const SampleCodeFakeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.image,
    required this.author,
    required this.name,
    required this.slug,
    required this.memberId,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    content,
    url,
    image,
    author,
    name,
    slug,
    memberId,
    publishedAt,
    createdAt,
    updatedAt,
  ];
}
