import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// This is the generated file from build_runner
import 'di_cc_sdk.config.dart';

/// Global service locator instance for the cc_sdk library.
final GetIt ccSdkLocator = GetIt.instance;

/// Configures and initializes all dependencies in the cc_sdk library.
///
/// Returns the configured [GetIt] instance.
@InjectableInit(
  initializerName: r'$initCcSdkDependencies',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt configureCcSdkDependencies() =>
    $initCcSdkDependencies(ccSdkLocator);
