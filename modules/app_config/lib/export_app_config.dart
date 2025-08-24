/// App Configuration Module
///
/// Provides environment-aware configuration and core functionality for the application.
///
/// ## Usage
///
/// ```dart
/// import 'package:app/export_app_config.dart';
///
/// // Get current environment
/// final env = AppConfig.environment;
///
/// // Get HTTP client for current environment
/// final httpClient = HttpClient.forEnvironment();
///
/// // Make API requests
/// final response = await httpClient.get('/api/data');
///
/// // Check feature flags
/// if (FeatureFlags.isEnableLogger) {
///   // Enable logging
/// }
/// ```

// Core Functionality
export 'box/cc_hive_box.dart';
export 'box/register_hive_adapter/register_hive_adapter.dart';
// App Configuration
export 'config/app/cc_app_config.dart';
export 'config/app/cc_app_track_info.dart';
// Feature Flags
export 'config/feature_flags.dart';
// Environment Configurations
export 'config/http/env/base.dart';
export 'config/http/env/free.dart';
export 'config/http/env/prod.dart';
export 'config/http/env/uat.dart';
// Core Configuration
export 'config/http/http_client/http_client_config.dart';
export 'config/http/models/request_header.dart';
// Constants
export 'constant/cc_constants.dart';
// Data Sources
export 'data_source/assets_data_source.dart';
// Enums
export 'enum/environment.dart';
export 'enum/layout_status.dart';
export 'enum/routing_manager_enum.dart';
// Extensions
export 'extension/app_track_log_extension.dart';
// Helpers
export 'helper/network_helper.dart';
