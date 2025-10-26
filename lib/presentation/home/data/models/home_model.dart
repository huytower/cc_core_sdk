import '../../domain/entities/home_entity.dart';

/// Home Model - Data Layer
///
/// This class extends the HomeEntity and adds data layer specific functionality
/// like JSON serialization. It follows the Liskov Substitution Principle
/// by being a proper subtype of HomeEntity.
class HomeModel extends HomeEntity {
  const HomeModel({
    required super.title,
    required super.description,
    required super.itemCount,
    required super.lastUpdated,
  });

  /// Creates a HomeModel from JSON data
  /// Following the Factory Pattern
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      title: json['title'] as String? ?? 'Default Title',
      description: json['description'] as String? ?? 'Default Description',
      itemCount: json['itemCount'] as int? ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  /// Converts the HomeModel to JSON data
  /// Following the Serialization Pattern
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'itemCount': itemCount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Creates a HomeModel from a HomeEntity
  /// Following the Adapter Pattern
  factory HomeModel.fromEntity(HomeEntity entity) {
    return HomeModel(
      title: entity.title,
      description: entity.description,
      itemCount: entity.itemCount,
      lastUpdated: entity.lastUpdated,
    );
  }

  /// Converts the HomeModel back to a HomeEntity
  /// Following the Adapter Pattern
  HomeEntity toEntity() {
    return HomeEntity(
      title: title,
      description: description,
      itemCount: itemCount,
      lastUpdated: lastUpdated,
    );
  }
}
