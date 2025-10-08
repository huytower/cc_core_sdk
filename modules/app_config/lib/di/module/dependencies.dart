import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../box/app_storage/cc_app_storage.dart';
import '../../box/app_track_log/cc_app_track_log.dart';
import '../../box/device_info/cc_device_info.dart';
import '../../helper/network_helper.dart';

/// Defines and provides common dependencies for the AppConfig module.
/// This module is responsible for registering services that are essential
/// for the application's configuration and infrastructure.
@module
abstract class AppConfigModule {
  /// Provides the application storage service.
  @lazySingleton
  CcAppStorage get ccAppStorage => CcAppStorage.instance;

  /// Provides device information service.
  @lazySingleton
  CcDeviceInfo get ccDeviceInfo => CcDeviceInfo.instance;

  /// Provides application tracking and logging service.
  @lazySingleton
  CcAppTrackLog get ccAppTrackLog => CcAppTrackLog.instance;

  /// Provides http connectivity checking service.
  @singleton
  NetworkHelper get networkHelper => NetworkHelper(
        InternetConnectionChecker.createInstance(),
      );
}
