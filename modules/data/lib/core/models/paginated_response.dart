import 'package:json_annotation/json_annotation.dart';

/// Response model for paginated data
@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  final List<T>? data;
  final int? currentPage;
  final int? perPage;
  final int? total;
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
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] as int?,
      perPage: json['per_page'] as int?,
      total: json['total'] as int?,
      totalPages: json['total_pages'] as int?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return {
      'data': data?.map((item) => toJsonT(item)).toList(),
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'total_pages': totalPages,
    };
  }
}
