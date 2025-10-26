import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// This is the generated file from build_runner
import 'di_app_config.config.dart';

/// Global service locator instance for the AppConfig module.
/// 
/// This provides access to all registered dependencies within the AppConfig module.
/// Prefer using constructor injection over service location when possible.
final GetIt appConfigLocator = GetIt.instance;

/// Configures and initializes all dependencies in the AppConfig module.
///
/// This function is called automatically by [initAppConfig] and should not be called directly
/// unless you need fine-grained control over the initialization process.
///
/// Returns the configured [GetIt] instance.
@InjectableInit(
  initializerName: r'$initAppConfigDependencies',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt configureDependencies() => $initAppConfigDependencies(appConfigLocator);

/// Initializes the AppConfig module with all its dependencies.
///
/// This is the main entry point for setting up the AppConfig module's dependency injection.
/// Call this during app startup before running the app.
///
/// Throws [Exception] if initialization fails.
///
/// Example:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await initAppConfig();
///   runApp(MyApp());
/// }
/// ```
Future<void> initAppConfig() async {
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
