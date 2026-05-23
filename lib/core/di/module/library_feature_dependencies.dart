import 'package:features/core/di/injection.dart' as features_di;
import 'package:features/counter/counter_init.dart';
import 'package:get_it/get_it.dart';

/// Configures all feature-related dependencies
/// This includes:
/// - Core features module initialization
/// - Feature-specific module configurations (Counter, etc.)
Future<void> configureLibraryFeatureDependencies() async {
  final getIt = GetIt.instance;

  // Initialize features module
  features_di.initMicroPackage();

  // Initialize counter feature
  initCounterFeature(getIt);
}
