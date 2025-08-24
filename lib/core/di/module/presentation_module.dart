import 'package:app_config/http/app_track_log/cc_app_track_log.dart';
import 'package:get_it/get_it.dart';

import '../../../screen/getx/app_track_log/cubit/logic/app_track_log_cubit.dart';

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
