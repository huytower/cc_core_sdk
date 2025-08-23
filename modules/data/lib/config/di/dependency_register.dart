// Core dependencies
import 'package:data/model/device/device_model.dart';
import 'package:data/model/sample/sample_model_watch_it.dart';
import 'package:data/model/sample/sample_model_watch_it_v2.dart';

import 'inject/data_inject.dart';

/// Registers all model-related singletons.
///
/// Models are registered as lazy singletons to ensure they're only
/// instantiated when first requested.
void registerDataModels() {
  // Register sample model implementations
  getItData.registerLazySingleton<SampleModelWatchItV2Notifier>(
    () => SampleModelWatchItV2Notifier(),
  );

  getItData.registerLazySingleton<SampleModelWatchItNotifier>(
    () => SampleModelWatchItNotifier(),
  );

  // Register device model
  getItData.registerLazySingleton<DeviceModelNotifier>(
    () => DeviceModelNotifier(),
  );
}
