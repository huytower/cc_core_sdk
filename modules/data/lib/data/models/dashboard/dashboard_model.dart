import '../../../domain/entities/dashboard/dashboard_entity.dart';

/// Dashboard Model - Data Layer
///
/// This class extends the DashboardEntity and adds data layer specific functionality
/// like JSON serialization. It follows the Liskov Substitution Principle
/// by being a proper subtype of DashboardEntity.
class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.title,
    required super.description,
    required super.itemCount,
    required super.lastUpdated,
  });

  /// Creates a DashboardModel from JSON data
  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      title: json['title'] as String? ?? 'Default Title',
      description: json['description'] as String? ?? 'Default Description',
      itemCount: json['itemCount'] as int? ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  /// Converts the DashboardModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'itemCount': itemCount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Converts the DashboardModel back to a DashboardEntity
  DashboardEntity toEntity() {
    return DashboardEntity(
      title: title,
      description: description,
      itemCount: itemCount,
      lastUpdated: lastUpdated,
    );
  }
}
