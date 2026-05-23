library counter_init;

import 'package:get_it/get_it.dart';

/// Counter Feature
///
/// This file serves as the main entry point for the counter feature.
/// It re-exports all the necessary files for the counter feature.

export 'counter_export.dart';

/// Initializes the counter feature.
/// This function should be called during app startup to configure
/// all dependencies for the counter feature.
void initCounterFeature(GetIt getIt) {
  // Dependencies are now handled by injectable in core/di/di.dart
}
