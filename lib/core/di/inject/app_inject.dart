import 'package:app_config/config/device_info/cc_device_info.dart';
import 'package:app_config/di/di_export.dart';
import 'package:cc_library/helper/device_helper.dart';
import 'package:cc_library/util/base_utils.dart';
import 'package:data/config/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../initializers/device_initializer.dart';
import '../../managers/hive_manager.dart';
import '../di_export.dart';
import '../module/library_feature_dependencies.dart';
import 'app_inject.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
Future<void> initializeDependencies() async {
  // Initialize app config dependencies
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

  if (!getIt.isRegistered<DeviceInitializer>()) {
    getIt.registerLazySingleton<DeviceInitializer>(
      () => DeviceInitializer(
        deviceInfo: getIt<CcDeviceInfo>(),
        deviceHelper: DeviceHelper(),
        baseUtils: BaseUtils(),
      ),
    );
  }
}
