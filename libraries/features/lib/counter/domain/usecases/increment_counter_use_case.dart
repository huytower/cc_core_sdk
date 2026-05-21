import 'package:injectable/injectable.dart';

import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

@lazySingleton
class IncrementCounterUseCase {
  final CounterRepository repository;

  IncrementCounterUseCase(this.repository);

  Future<CounterEntity> call(CounterEntity current) async {
    final updated = current.copyWith(value: current.value + 1);
    await repository.saveCounter(updated);
    return updated;
  }
}
