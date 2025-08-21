import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

/// Get Home Data Use Case - Domain Layer
///
/// This use case is responsible for retrieving home data.
/// It follows the Single Responsibility Principle by having only one reason to change.
/// It also follows the Dependency Inversion Principle by depending on the repository interface.
class GetHomeDataUseCase {
  final HomeRepository repository;

  const GetHomeDataUseCase(this.repository);

  /// Executes the use case to retrieve home data
  /// Returns a Future with HomeEntity
  Future<HomeEntity> call() async {
    return await repository.getHomeData();
  }
}
