/// A collection of reusable feature modules for the application.
///
/// This library serves as the main entry point for all feature modules.
/// Individual features should be imported and re-exported from here.
library features;

// Feature exports
export 'counter/presentation/pages/counter_page.dart';
export 'core/constants/app_constants.dart';
// Core exports
export 'core/di/injection.dart';
export 'core/utils/app_utils.dart';
export 'features.dart';
