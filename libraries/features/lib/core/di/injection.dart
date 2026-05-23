import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Global service locator for the features library
final getIt = GetIt.instance;

/// Configures dependency injection for the features library
///
/// Call this function during app initialization to set up all dependencies
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await getIt.init();
}
