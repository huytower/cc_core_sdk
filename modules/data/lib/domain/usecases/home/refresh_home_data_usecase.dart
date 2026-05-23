import 'package:injectable/injectable.dart';

import '../../entities/home/home_entity.dart';
import '../../repositories/home/home_repository.dart';

/// Refresh Home Data Use Case - Domain Layer
///
/// This use case is responsible for refreshing home data from the source.
/// It follows the Single Responsibility Principle by having only one reason to change.
/// It also follows the Dependency Inversion Principle by depending on the repository interface.
@lazySingleton
class RefreshHomeDataUseCase {
  final HomeRepository repository;

  const RefreshHomeDataUseCase(this.repository);

  /// Executes the use case to refresh home data
  /// Returns a Future with the refreshed HomeEntity
  Future<HomeEntity> call() async {
    return await repository.refreshHomeData();
  }
}
