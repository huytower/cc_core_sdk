import 'package:app_config/core/di/di_app_config.module.dart';
import 'package:cc_sdk/core/di/di_cc_sdk.module.dart';
import 'package:data/core/di/inject/data_inject.module.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:features/core/di/injection.module.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

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
  // Initialize all dependencies (including Micro-Packages from cc_sdk, features, data, etc.)
  // This will automatically call the init functions of all discovered micro-packages.
  await getIt.init();
}
