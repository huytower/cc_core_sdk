import 'package:cc_sdk/src/core/config/cc_sdk_config.dart';

/// Centralized route configuration provider, so modules can navigate to the
/// main and login screens without importing each other.
///
/// Values come from [CcSdkConfig.current].
class CcRouteConfig {
  /// The path to the main navigation (home) screen.
  static String get mainNavigation => CcSdkConfig.current.mainNavigationPath;

  /// The path to the login screen.
  static String get login => CcSdkConfig.current.loginPath;
}
