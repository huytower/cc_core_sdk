import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

/// Update Home Data Use Case - Domain Layer
///
/// This use case is responsible for updating home data.
/// It follows the Single Responsibility Principle by having only one reason to change.
/// It also follows the Dependency Inversion Principle by depending on the repository interface.
class UpdateHomeDataUseCase {
  final HomeRepository repository;

  const UpdateHomeDataUseCase(this.repository);

  /// Executes the use case to update home data
  /// Takes a HomeEntity and returns a Future with the updated entity
  Future<HomeEntity> call(HomeEntity homeData) async {
    return await repository.updateHomeData(homeData);
  }
}
