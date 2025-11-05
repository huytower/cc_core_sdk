import 'package:json_annotation/json_annotation.dart';

part 'pagination_model.g.dart';

/// Represents pagination information for API responses
@JsonSerializable(genericArgumentFactories: true)
class PaginationModel<T> {
  /// List of items in the current page
  final List<T> items;

  /// Current page number (1-based index)
  final int currentPage;

  /// Number of items per page
  final int itemsPerPage;

  /// Total number of items across all pages
  final int totalItems;

  /// Total number of pages
  int get totalPages => (totalItems / itemsPerPage).ceil();

  /// Whether there are more items to load
  bool get hasMore => currentPage < totalPages;

  const PaginationModel({
    required this.items,
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalItems,
  });

  /// Creates a copy of this pagination model with updated fields
  PaginationModel<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? itemsPerPage,
    int? totalItems,
  }) {
    return PaginationModel<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  /// Creates a PaginationModel from JSON
  factory PaginationModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    return PaginationModel<T>(
      items: (json['data'] as List<dynamic>)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] ?? 1,
      itemsPerPage: json['per_page'] ?? 10,
      totalItems: json['total'] ?? 0,
    );
  }

  /// Converts this pagination model to JSON
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return {
      'data': items.map((e) => toJsonT(e)).toList(),
      'current_page': currentPage,
      'per_page': itemsPerPage,
      'total': totalItems,
    };
  }
}
