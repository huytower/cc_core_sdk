// Core dependencies
import 'package:data/model/device/device_model.dart';
import 'package:data/model/sample/sample_model_watch_it.dart';
import 'package:data/model/sample/sample_model_watch_it_v2.dart';
import 'package:data/repositories/comment/comment_repositories.dart';

// Feature dependencies
import '../../screen/getx/comment/get_x/comment_controller.dart';
import '../../screen/getx/web/get_x/web_controller.dart';
// Local dependencies
import 'inject/app_inject.dart';

/// Centralized dependency registration for the application.
///
/// This file is responsible for registering all singleton dependencies
/// used throughout the application. It's organized by feature and dependency type
/// for better maintainability and discoverability.

/// Initializes all singleton dependencies in the application.
///
/// This should be called during app startup to ensure all dependencies
/// are properly registered before they're needed.
void registerSingletonApp() {
  _registerControllers();
  _registerModels();
}

/// Registers all model-related singletons.
///
/// Models are registered as lazy singletons to ensure they're only
/// instantiated when first requested.
void _registerModels() {
  // Register sample model implementations
  getIt.registerLazySingleton<SampleModelWatchItV2Notifier>(
    () => SampleModelWatchItV2Notifier(),
  );

  getIt.registerLazySingleton<SampleModelWatchItNotifier>(
    () => SampleModelWatchItNotifier(),
  );

  // Register device model
  getIt.registerLazySingleton<DeviceModelNotifier>(
    () => DeviceModelNotifier(),
  );
}

/// Registers all controller-related singletons.
///
/// Controllers are registered as lazy singletons and may depend on
/// other registered services or repositories.
void _registerControllers() {
  // Register web controller
  getIt.registerLazySingleton<WebController>(
    () => WebController(),
  );

  // Register comment controller with its dependencies
  getIt.registerLazySingleton<CommentController>(
    () => CommentController(
      getIt<CommentRepository>(),
    ),
  );
}
