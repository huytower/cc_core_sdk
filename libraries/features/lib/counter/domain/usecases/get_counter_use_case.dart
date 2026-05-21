import 'package:injectable/injectable.dart';

import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

@lazySingleton
class GetCounterUseCase {
  final CounterRepository repository;

  GetCounterUseCase(this.repository);

  Future<CounterEntity> call() async {
    return await repository.getCounter();
  }
}
