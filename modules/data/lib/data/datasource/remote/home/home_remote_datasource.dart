import '../../../../domain/entities/home/home_entity.dart';

/// Home Remote Data Source Interface - Data Layer
///
/// This interface defines the contract for remote data operations.
/// It follows the Interface Segregation Principle by having focused methods.
abstract class HomeRemoteDataSource {
  /// Fetches home data from remote API
  Future<HomeEntity> fetchHomeData();

  /// Updates home data on remote API
  Future<HomeEntity> updateHomeData(HomeEntity homeData);
}
