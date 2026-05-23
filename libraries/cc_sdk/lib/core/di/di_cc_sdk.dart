import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di_cc_sdk.config.dart';

/// Global service locator instance for the cc_sdk library.
final GetIt ccSdkLocator = GetIt.instance;

/// Configures and initializes all dependencies in the cc_sdk library.
///
/// Uses the auto-registering pattern (extension method on GetIt).
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureCcSdkDependencies() => ccSdkLocator.init();
