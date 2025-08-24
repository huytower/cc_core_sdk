import 'package:app_config/di/export_di_app_config.dart';
import 'package:app_config/http/device_info/cc_device_info.dart';
import 'package:data/config/di/di_export.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/device/device_dimension_manager.dart';
import '../../common/device/device_info_manager.dart';
import '../../common/device/device_initializer.dart';
import '../../common/managers/hive_manager.dart';
import '../di_export.dart';
import '../module/library_feature_dependencies.dart';
import 'inject.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
Future<void> initializeDependencies() async {
  // Initialize app http dependencies
  await initializeAppConfigDependencies(getIt);

  // Initialize data layer dependencies
  await configureDataDependencies(getIt);

  // Initialize feature dependencies
  await configureLibraryFeatureDependencies();

  // Initialize presentation layer dependencies
  await configurePresentationDependencies();

  // Initialize core dependencies
  await _configureCoreDependencies();

  // Initialize the rest of dependencies
  getIt.$initGetIt();
}

Future<void> _configureCoreDependencies() async {
  // Initialize SharedPreferences
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // Register core managers and initializers
  if (!getIt.isRegistered<HiveManager>()) {
    getIt.registerLazySingleton<HiveManager>(() => HiveManager());
  }

  // Register device-related dependencies
  if (!getIt.isRegistered<DeviceInfoManager>()) {
    getIt.registerLazySingleton<DeviceInfoManager>(
      () => DeviceInfoManager(getIt<CcDeviceInfo>()),
    );
  }

  if (!getIt.isRegistered<DeviceDimensionManager>()) {
    getIt.registerLazySingleton<DeviceDimensionManager>(
      () => DeviceDimensionManager(getIt<CcDeviceInfo>()),
    );
  }

  if (!getIt.isRegistered<DeviceInitializer>()) {
    getIt.registerLazySingleton<DeviceInitializer>(
      () => DeviceInitializer.withDefaults(
        deviceInfo: getIt<CcDeviceInfo>(),
      ),
    );
  }
}
