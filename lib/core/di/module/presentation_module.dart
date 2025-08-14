import 'package:app_config/config/app_track_log/cc_app_track_log.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../../presentation/app_track_log/cubit/logic/app_track_log_cubit.dart';
import '../../../presentation/sample_code/bloc_simple_page/cubit/simple/simple_cubit.dart';
import '../../../presentation/sample_code/bloc_simple_page/cubit/simple/simple_cubit_interface.dart';

@module
abstract class PresentationModule {
  // This module is intentionally left empty as we'll use explicit registration
  // in the configureDependencies function below
}

// Helper function to configure dependencies
void configureDependencies() {
  final getIt = GetIt.instance;

  // Register AppTrackLogCubit
  if (!getIt.isRegistered<AppTrackLogCubit>()) {
    getIt.registerLazySingleton<AppTrackLogCubit>(
      () => AppTrackLogCubit(getIt<CcAppTrackLog>()),
    );
  }

  // Register SimpleCubit with its interface
  if (!getIt.isRegistered<SimpleCubitInterface>()) {
    getIt.registerLazySingleton<SimpleCubitInterface>(
      () => SimpleCubit(),
    );
  }
}

// This is needed for the injectable generator
typedef FactoryFunc<T> = T Function();

// This is needed for the injectable generator
abstract class RegisterModule {
  void registerDependencies();
}
