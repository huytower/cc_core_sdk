import '../../domain/entities/home_entity.dart';
import '../models/home_model.dart';
import 'home_remote_datasource.dart';

/// Home Remote Data Source Implementation - Data Layer
/// 
/// This is a mock implementation of the HomeRemoteDataSource interface.
/// In a real application, this would make HTTP requests to a remote API.
/// It follows the Single Responsibility Principle by only handling remote data operations.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  @override
  Future<HomeEntity> fetchHomeData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate random data for demonstration
    final random = DateTime.now().millisecondsSinceEpoch;
    final titles = [
      'Welcome to Flutter',
      'Clean Architecture Home',
      'BLoC Pattern Demo',
      'SOLID Principles in Action',
    ];
    
    return HomeModel(
      title: titles[random % titles.length],
      description: 'This is a demonstration of Clean Architecture with BLoC pattern and SOLID principles.',
      itemCount: random % 100,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<HomeEntity> updateHomeData(HomeEntity homeData) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would send data to the server
    // For now, just return the updated data with a new timestamp
    return homeData.copyWith(
      lastUpdated: DateTime.now(),
    );
  }
}
