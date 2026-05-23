import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'data_inject.config.dart';

GetIt getItData = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDataDependencies(GetIt getIt) async {
  getItData = getIt;
  getIt.init();
}
