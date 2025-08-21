import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di_initializer.config.dart';

/// Global GetIt instance for AppConfig module
GetIt appConfigLocator = GetIt.instance;

@InjectableInit(initializerName: r'$initAppConfigDependencies')
Future<void> initializeAppConfigDependencies(GetIt getIt) async {
  appConfigLocator = getIt;

  getIt.$initAppConfigDependencies();
}
