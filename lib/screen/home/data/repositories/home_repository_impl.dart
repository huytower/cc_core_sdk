import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';

/// Home Repository Implementation - Data Layer
/// 
/// This class implements the HomeRepository interface and coordinates
/// between local and remote data sources. It follows the Repository Pattern
/// and the Single Responsibility Principle by managing data operations.
class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource _localDataSource;
  final HomeRemoteDataSource _remoteDataSource;

  const HomeRepositoryImpl({
    required HomeLocalDataSource localDataSource,
    required HomeRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<HomeEntity> getHomeData() async {
    try {
      // First try to get data from local storage
      final localData = await _localDataSource.getHomeData();
      
      // Check if local data is fresh (less than 1 hour old)
      final isDataFresh = DateTime.now().difference(localData.lastUpdated).inHours < 1;
      
      if (isDataFresh) {
        return localData;
      }
      
      // If local data is stale, try to fetch from remote
      try {
        final remoteData = await _remoteDataSource.fetchHomeData();
        // Cache the fresh data locally
        await _localDataSource.saveHomeData(remoteData);
        return remoteData;
      } catch (e) {
        // If remote fails, return local data as fallback
        return localData;
      }
    } catch (e) {
      // If local also fails, try remote as last resort
      try {
        final remoteData = await _remoteDataSource.fetchHomeData();
        await _localDataSource.saveHomeData(remoteData);
        return remoteData;
      } catch (remoteError) {
        throw Exception('Failed to get home data from both local and remote sources: $remoteError');
      }
    }
  }

  @override
  Future<HomeEntity> updateHomeData(HomeEntity homeData) async {
    try {
      // Update remote first
      final updatedRemoteData = await _remoteDataSource.updateHomeData(homeData);
      
      // Then update local cache
      await _localDataSource.saveHomeData(updatedRemoteData);
      
      return updatedRemoteData;
    } catch (e) {
      // If remote update fails, try to update local only
      try {
        await _localDataSource.saveHomeData(homeData);
        return homeData;
      } catch (localError) {
        throw Exception('Failed to update home data: $e, Local error: $localError');
      }
    }
  }

  @override
  Future<HomeEntity> refreshHomeData() async {
    try {
      // Force refresh from remote
      final freshData = await _remoteDataSource.fetchHomeData();
      
      // Update local cache with fresh data
      await _localDataSource.saveHomeData(freshData);
      
      return freshData;
    } catch (e) {
      throw Exception('Failed to refresh home data: $e');
    }
  }
}
