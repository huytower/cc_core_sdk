import 'package:app_config/core/di/di.module.dart';
import 'package:cc_sdk/core/di/di.module.dart';
import 'package:data/core/di/di.module.dart';
import 'package:features/core/di/di.module.dart';
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
)
Future<void> initializeDependencies() async {
  // Initialize all dependencies (including Micro-Packages from cc_sdk, features, data, etc.)
  // This will automatically call the init functions of all discovered micro-packages.
  // All singletons with @disposeMethod are auto-wired for disposal via getIt.reset().
  await getIt.init();
}
