import 'package:get_it/get_it.dart';

import '../domain/usecases/get_home_data_usecase.dart';
import '../domain/usecases/refresh_home_data_usecase.dart';
import '../domain/usecases/update_home_data_usecase.dart';
import '../presentation/bloc/home_bloc.dart';

/// Home Module - Dependency Injection
/// 
/// This module configures only the BLoC for the home feature.
/// Other dependencies are managed by HomeDependencyModule using injectable.
class HomeModule {
  final GetIt _getIt;

  const HomeModule(this._getIt);

  /// Configures BLoC dependencies for the home feature
  void configure() {
    _configureBloc();
  }

  /// Configures BLoC dependencies
  void _configureBloc() {
    _getIt.registerFactory(
      () => HomeBloc(
        getHomeDataUseCase: _getIt<GetHomeDataUseCase>(),
        updateHomeDataUseCase: _getIt<UpdateHomeDataUseCase>(),
        refreshHomeDataUseCase: _getIt<RefreshHomeDataUseCase>(),
      ),
    );
  }
}
