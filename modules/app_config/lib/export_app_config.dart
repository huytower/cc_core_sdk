/// App Configuration Module
///
/// Provides environment-aware configuration for the application.
///
/// ## Usage
///
/// ```dart
/// import 'package:app_config/export_app_config.dart';
///
/// // Get current environment
/// final env = CcAppConfig.environment;
///
/// // Get app config for current environment
/// final config = CcAppConfig.instance;
/// print('App Name: ${config.appName}');
/// print('API URL: ${config.baseUrl}');
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
export 'core/box/cc_hive_box.dart';
export 'core/box/register_hive_adapter/register_hive_adapter.dart';
// Core Configuration
export 'core/config/app_config/cc_app_config.dart';
// Constants
export 'core/constant/assets_resource.dart';
export 'core/constant/cc_constants.dart';
// Enums
export 'core/enum/cc_vpn_status.dart';
// Environment
export 'core/enum/environment.dart';
export 'core/enum/layout_status.dart';
export 'core/enum/routing_manager_enum.dart';
// Extensions
export 'extension/app_track_log_extension.dart';
// Helpers
export 'helper/network_helper.dart';
