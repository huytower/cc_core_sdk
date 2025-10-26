import '../entities/home_entity.dart';

/// Home Repository Interface - Domain Layer
///
/// This abstract interface defines the contract for home data operations.
/// It follows the Dependency Inversion Principle by depending on abstractions,
/// not concrete implementations.
abstract class HomeRepository {
  /// Retrieves the home data
  /// Returns a Future with HomeEntity or throws an exception
  Future<HomeEntity> getHomeData();

  /// Updates the home data
  /// Takes a HomeEntity and returns a Future with the updated entity
  Future<HomeEntity> updateHomeData(HomeEntity homeData);

  /// Refreshes the home data from the source
  /// Returns a Future with the refreshed HomeEntity
  Future<HomeEntity> refreshHomeData();
}
