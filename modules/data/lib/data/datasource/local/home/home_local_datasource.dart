import '../../../../domain/entities/home/home_entity.dart';

/// Home Local Data Source Interface - Data Layer
///
/// This interface defines the contract for local data operations.
/// It follows the Interface Segregation Principle by having focused methods.
abstract class HomeLocalDataSource {
  /// Retrieves home data from local storage
  Future<HomeEntity> getHomeData();

  /// Saves home data to local storage
  Future<void> saveHomeData(HomeEntity homeData);

  /// Clears home data from local storage
  Future<void> clearHomeData();
}
