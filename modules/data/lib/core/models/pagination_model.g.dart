// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationModel<T> _$PaginationModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PaginationModel<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  currentPage: (json['currentPage'] as num).toInt(),
  itemsPerPage: (json['itemsPerPage'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
);

Map<String, dynamic> _$PaginationModelToJson<T>(
  PaginationModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'currentPage': instance.currentPage,
  'itemsPerPage': instance.itemsPerPage,
  'totalItems': instance.totalItems,
};
