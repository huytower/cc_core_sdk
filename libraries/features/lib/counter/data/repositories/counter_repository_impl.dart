import '../../domain/entities/counter_entity.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_data_source.dart';

class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;

  CounterRepositoryImpl({required this.localDataSource});

  @override
  Future<CounterEntity> getCounter() async {
    return await localDataSource.getCounter();
  }

  @override
  Future<void> saveCounter(CounterEntity counter) async {
    await localDataSource.saveCounter(counter);
  }
}
