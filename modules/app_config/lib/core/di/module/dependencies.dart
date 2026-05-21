import 'package:cc_sdk/core/helper/cc_network_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../data/datasource/local/box/app_storage/cc_app_storage.dart';
import '../../../data/datasource/local/box/device_info/cc_device_info.dart';
import '../../../data/datasource/remote/app_version_api.dart';

/// A module that defines and provides all dependencies for the AppConfig module.
///
/// This class uses the `@module` annotation to mark it as a dependency module.
/// Each dependency is provided through getter methods with appropriate scoping.
@module
abstract class AppConfigModule {
  /// Provides a singleton instance of [CcAppStorage].
  ///
  /// [CcAppStorage] handles application-level storage operations and is registered
  /// as a lazy singleton to maintain a single source of truth for app storage.
  @lazySingleton
  CcAppStorage get ccAppStorage => CcAppStorage.instance;

  /// Provides a singleton instance of [CcDeviceInfo].
  ///
  /// [CcDeviceInfo] provides device-specific information and is registered
  /// as a lazy singleton since device information doesn't change during app lifecycle.
  @lazySingleton
  CcDeviceInfo get ccDeviceInfo => CcDeviceInfo.instance;

  /// Provides a singleton instance of [CcNetworkHelper].
  @singleton
  CcNetworkHelper get networkHelper => CcNetworkHelper(InternetConnection());

  /// Provides a singleton instance of [AppVersionAPI].
  ///
  /// [AppVersionAPI] handles version checking and update-related functionality.
  /// It's registered as a lazy singleton to maintain consistency across the app.
  @lazySingleton
  AppVersionAPI get appVersionService => AppVersionAPI();
}
