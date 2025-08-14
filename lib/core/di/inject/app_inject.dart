import 'package:app_config/di/inject/app_config_inject.dart';
import 'package:data/config/di/inject/data_inject.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../module/presentation_module.dart';
import 'app_inject.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
Future appInject() async {
  // Initialize app config dependencies
  await appConfigInject(getIt);

  // Initialize data layer dependencies
  await dataInject(getIt);

  // Initialize presentation layer dependencies
  configureDependencies();

  // Run the injectable generator's initialization
  getIt.$initGetIt();
}
