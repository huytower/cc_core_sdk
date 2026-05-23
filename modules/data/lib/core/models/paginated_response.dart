import 'package:json_annotation/json_annotation.dart';

part 'paginated_response.g.dart';

/// Response model for paginated data
@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  final List<T>? data;
  @JsonKey(name: 'current_page')
  final int? currentPage;
  @JsonKey(name: 'per_page')
  final int? perPage;
  final int? total;
  @JsonKey(name: 'total_pages')
  final int? totalPages;

  PaginatedResponse({
    this.data,
    this.currentPage,
    this.perPage,
    this.total,
    this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$PaginatedResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);
}
