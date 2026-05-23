import 'package:app_config/core/di/di.module.dart';
import 'package:cc_sdk/core/di/di.module.dart';
import 'package:data/core/di/di.module.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:features/core/di/di.module.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../common/managers/hive_manager.dart';
import '../di_export.dart';
import 'inject.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
  externalPackageModulesBefore: [
    ExternalModule(CcSdkPackageModule),
    ExternalModule(DataPackageModule),
    ExternalModule(AppConfigPackageModule),
    ExternalModule(FeaturesPackageModule),
  ],
  ignoreUnregisteredTypes: [DeviceInfoPlugin],
)
Future<void> initializeDependencies() async {
  // Initialize common dependencies that might be needed by others
  await _configureCoreDependencies();

  // Initialize all dependencies (including Micro-Packages from cc_sdk, features, data, etc.)
  // This will automatically call the init functions of all discovered micro-packages.
  await getIt.init();

  // Initialize presentation layer dependencies
  await configurePresentationDependencies();
}

Future<void> _configureCoreDependencies() async {
  // Register common managers and initializers
  if (!getIt.isRegistered<HiveManager>()) {
    getIt.registerLazySingleton<HiveManager>(() => HiveManager());
  }
}
