import 'package:app_config/config/app_track_log/cc_app_track_log.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../../screen/getx/app_track_log/cubit/logic/app_track_log_cubit.dart';

@module
abstract class PresentationModule {
  // This module is intentionally left empty as we'll use explicit registration
  // in the configureDependencies function below
}

/// Configures presentation layer specific dependencies
Future<void> configurePresentationDependencies() async {
  final getIt = GetIt.instance;

  // Register AppTrackLogCubit
  if (!getIt.isRegistered<AppTrackLogCubit>()) {
    getIt.registerLazySingleton<AppTrackLogCubit>(
      () => AppTrackLogCubit(getIt<CcAppTrackLog>()),
    );
  }
}
