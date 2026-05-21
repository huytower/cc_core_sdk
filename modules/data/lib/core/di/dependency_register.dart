import '../../data/model/device/device_model.dart';
import 'inject/data_inject.dart';

/// Registers all model-related singletons.
///
/// Models are registered as lazy singletons to ensure they're only
/// instantiated when first requested.
void registerDataModels() {
  // Register device model
  getItData.registerLazySingleton<DeviceModelNotifier>(
    () => DeviceModelNotifier(),
  );
}
