import 'package:app_config/core/di/di_app_config.dart';
import 'package:data/core/di/inject/data_inject.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/managers/hive_manager.dart';
import '../di_export.dart';
import '../module/library_feature_dependencies.dart';
import 'inject.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
Future<void> initializeDependencies() async {
  // Initialize app http dependencies
  await initAppConfig();

  // Initialize data layer dependencies
  await configureDataDependencies(getIt);

  // Initialize feature dependencies
  await configureLibraryFeatureDependencies();

  // Initialize presentation layer dependencies
  await configurePresentationDependencies();

  // Initialize common dependencies
  await _configureCoreDependencies();

  // Initialize the rest of dependencies
  getIt.$initGetIt();
}

Future<void> _configureCoreDependencies() async {
  // Initialize SharedPreferences
  if (!getIt.isRegistered<SharedPreferences>()) {
    final sharedPrefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  }

  // Register common managers and initializers
  if (!getIt.isRegistered<HiveManager>()) {
    getIt.registerLazySingleton<HiveManager>(() => HiveManager());
  }
}
