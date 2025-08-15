import 'package:app_config/di/di_export.dart';
import 'package:data/config/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di_export.dart';
import '../module/library_feature_dependencies.dart';
import 'app_inject.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
Future<void> initializeDependencies() async {
  // Initialize SharedPreferences
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // Initialize app config dependencies
  await configureModuleAppConfigDependencies(getIt);

  // Initialize data layer dependencies
  await configureDataDependencies(getIt);

  // Initialize feature dependencies
  await configureLibraryFeatureDependencies();

  // Initialize presentation layer dependencies
  await configurePresentationDependencies();

  // Run the injectable generator's initialization
  getIt.$initGetIt();
}
