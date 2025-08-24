/// App Configuration Module
///
/// Provides env-aware configuration and core functionality for the application.
///
/// ## Usage
///
/// ```dart
/// import 'package:app_config/export_app_config.dart';
///
/// // Get current env
/// final env = CcAppConfig.env;
///
/// // Get app http for current env
/// final http = CcAppConfig.instance;
/// print('App Name: ${http.appName}');
/// print('API URL: ${http.baseUrl}');
///
/// // Check feature flags
/// if (CcAppConfigFlags.isEnableLogger) {
///   // Enable logging
/// }
///
/// // Get app name
/// final appName = CcAppName.appName;
///
/// // Get base URL
/// final baseUrl = CcAppHostUrlName.baseUrl;
/// ```

// Core functionality
export 'box/cc_hive_box.dart';
export 'box/register_hive_adapter/register_hive_adapter.dart';
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
// Core Configuration
export 'http/http_client/http_client.dart';
