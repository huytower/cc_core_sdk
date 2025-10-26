import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// This is the generated file from build_runner
import 'di_app_config.config.dart';

/// Global GetIt instance for AppConfig module
final GetIt appConfigLocator = GetIt.instance;

/// Initialize all dependencies in the AppConfig module
///
/// Call this function in your app's main function before running the app
@InjectableInit(
  initializerName: r'$initAppConfigDependencies',
  preferRelativeImports: true,
  asExtension: false,
)
Future<GetIt> configureDependencies() async {
  return await $initAppConfigDependencies(appConfigLocator);
}

/// Initialize the AppConfig module with required setup
///
/// This is a convenience method that should be called during app startup
/// to ensure all dependencies are properly initialized
Future<GetIt> initAppConfig() async {
  try {
    // Initialize Hive adapters first if needed
    // await RegisterHiveAdapter().register();

    // Configure all dependencies
    return await configureDependencies();
  } catch (e, stackTrace) {
    print('Error initializing AppConfig: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}
