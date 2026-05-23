import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../domain/entities/home/home_entity.dart';
import '../../../models/home/home_model.dart';
import 'home_local_datasource.dart';

/// Home Local Data Source Implementation - Data Layer
///
/// This class implements the HomeLocalDataSource interface using SharedPreferences.
/// It follows the Single Responsibility Principle by only handling local storage operations.
@LazySingleton(as: HomeLocalDataSource)
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  static const String _titleKey = 'home_title';
  static const String _descriptionKey = 'home_description';
  static const String _itemCountKey = 'home_item_count';
  static const String _lastUpdatedKey = 'home_last_updated';

  final SharedPreferences _sharedPreferences;

  const HomeLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<HomeEntity> getHomeData() async {
    try {
      final title = _sharedPreferences.getString(_titleKey) ?? 'Welcome Home';
      final description =
          _sharedPreferences.getString(_descriptionKey) ??
          'This is your home presentation';
      final itemCount = _sharedPreferences.getInt(_itemCountKey) ?? 0;
      final lastUpdatedString = _sharedPreferences.getString(_lastUpdatedKey);

      final lastUpdated = lastUpdatedString != null
          ? DateTime.parse(lastUpdatedString)
          : DateTime.now();

      return HomeModel(
        title: title,
        description: description,
        itemCount: itemCount,
        lastUpdated: lastUpdated,
      );
    } catch (e) {
      // Return default data if there's an error
      return HomeModel(
        title: 'Welcome Home',
        description: 'This is your home presentation',
        itemCount: 0,
        lastUpdated: DateTime.now(),
      );
    }
  }

  @override
  Future<void> saveHomeData(HomeEntity homeData) async {
    try {
      await _sharedPreferences.setString(_titleKey, homeData.title);
      await _sharedPreferences.setString(_descriptionKey, homeData.description);
      await _sharedPreferences.setInt(_itemCountKey, homeData.itemCount);
      await _sharedPreferences.setString(
        _lastUpdatedKey,
        homeData.lastUpdated.toIso8601String(),
      );
    } catch (e) {
      throw Exception('Failed to save home data: $e');
    }
  }

  @override
  Future<void> clearHomeData() async {
    try {
      await _sharedPreferences.remove(_titleKey);
      await _sharedPreferences.remove(_descriptionKey);
      await _sharedPreferences.remove(_itemCountKey);
      await _sharedPreferences.remove(_lastUpdatedKey);
    } catch (e) {
      throw Exception('Failed to clear home data: $e');
    }
  }
}
