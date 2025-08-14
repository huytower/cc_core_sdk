import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/counter_local_data_source.dart';
import '../data/repositories/counter_repository_impl.dart';
import '../domain/repositories/counter_repository.dart';
import '../domain/usecases/get_counter_use_case.dart';
import '../domain/usecases/increment_counter_use_case.dart';
import '../presentation/bloc/counter_bloc.dart';

class CounterModule {
  final GetIt getIt;

  CounterModule(this.getIt);

  void configure() {
    // Data sources
    getIt.registerLazySingleton<CounterLocalDataSource>(
      () => CounterLocalDataSourceImpl(
        sharedPreferences: getIt<SharedPreferences>(),
      ),
    );

    // Repositories
    getIt.registerLazySingleton<CounterRepository>(
      () => CounterRepositoryImpl(
        localDataSource: getIt<CounterLocalDataSource>(),
      ),
    );

    // Use cases
    getIt.registerLazySingleton(
      () => GetCounterUseCase(getIt<CounterRepository>()),
    );
    getIt.registerLazySingleton(
      () => IncrementCounterUseCase(getIt<CounterRepository>()),
    );

    // BLoC
    getIt.registerFactory(
      () => CounterBloc(
        getCounterUseCase: getIt<GetCounterUseCase>(),
        incrementCounterUseCase: getIt<IncrementCounterUseCase>(),
      ),
    );
  }
}
