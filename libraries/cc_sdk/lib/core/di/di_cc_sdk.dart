import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// This is the generated file from build_runner
import 'di_cc_sdk.config.dart';

final ccSdkLocator = GetIt.instance;

/// Configures and initializes all dependencies in the cc_sdk library.
///
/// Returns the configured [GetIt] instance.
@InjectableInit(
  initializerName: r'$initCcSdkDependencies',
  preferRelativeImports: true, // default
  asExtension: false,
)
GetIt configureDependencies() => $initCcSdkDependencies(ccSdkLocator);

Future<void> initCcSdk() async {
  try {
    // Initialize any required services before dependency injection
    // Example: await RegisterHiveAdapter().register();

    // Configure all dependencies
    configureDependencies();

    // Initialize any services that need post-DI setup
    // Example: await appConfigLocator<SomeService>().initialize();
  } catch (e, stackTrace) {
    // Log the error with a descriptive message
    print('Failed to initialize AppConfig module: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}
