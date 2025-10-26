import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../core/helper/network_helper.dart';
import '../../../data/datasource/local/box/app_storage/cc_app_storage.dart';
import '../../../data/datasource/local/box/app_track_log/cc_app_track_log.dart';
import '../../../data/datasource/local/box/device_info/cc_device_info.dart';
import '../../../data/datasource/remote/app_version_service.dart';

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

  /// Provides a singleton instance of [CcAppTrackLog].
  ///
  /// [CcAppTrackLog] handles application logging and tracking, registered
  /// as a lazy singleton to maintain consistent logging throughout the app.
  @lazySingleton
  CcAppTrackLog get ccAppTrackLog => CcAppTrackLog.instance;

  /// Provides a singleton instance of [NetworkHelper].
  ///
  /// The [NetworkHelper] is a utility class for handling network-related operations
  /// and is registered as a singleton to ensure consistent network state management.
  @singleton
  NetworkHelper get networkHelper => NetworkHelper(
        InternetConnectionChecker.createInstance(),
      );

  /// Provides a singleton instance of [AppVersionService].
  ///
  /// [AppVersionService] handles version checking and update-related functionality.
  /// It's registered as a lazy singleton to maintain consistency across the app.
  @lazySingleton
  AppVersionService get appVersionService => AppVersionService();
}
