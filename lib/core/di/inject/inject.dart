import 'package:app_config/core/di/di_app_config.dart';
import 'package:data/core/di/inject/data_inject.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../common/managers/hive_manager.dart';
import '../di_export.dart';
import '../module/library_feature_dependencies.dart';
import 'inject.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> initializeDependencies() async {
  // Initialize app http dependencies
  await initAppConfig();

  // Initialize common dependencies (SharedPreferences needed by data layer)
  await _configureCoreDependencies();

  // Initialize feature dependencies (provides SharedPreferences via @preResolve)
  await configureLibraryFeatureDependencies();

  // Initialize data layer dependencies
  await configureDataDependencies(getIt);

  // Initialize presentation layer dependencies
  await configurePresentationDependencies();

  // Initialize the rest of dependencies
  getIt.init();
}

Future<void> _configureCoreDependencies() async {
  // Register common managers and initializers
  if (!getIt.isRegistered<HiveManager>()) {
    getIt.registerLazySingleton<HiveManager>(() => HiveManager());
  }
}
