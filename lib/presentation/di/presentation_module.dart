import 'package:app_config/config/app_track_log/cc_app_track_log.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../app_track_log/cubit/logic/app_track_log_cubit.dart';

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
}

// This is needed for the injectable generator
typedef FactoryFunc<T> = T Function();

// This is needed for the injectable generator
abstract class RegisterModule {
  void registerDependencies();
}
