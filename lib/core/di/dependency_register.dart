// Feature dependencies
import 'package:data/core/di/dependency_register.dart';
import 'package:data/domain/repositories/comment/comment_repositories.dart';

import '../../presentation/getx/comment/get_x/comment_controller.dart';
import '../../presentation/getx/web/get_x/web_controller.dart';
// Local dependencies
import 'inject/inject.dart';

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
  registerDataModels();
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
