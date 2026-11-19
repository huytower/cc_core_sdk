import 'package:cc_sdk_data/domain/entities/cc_device_entity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/cc_device_info_helper.dart';

/// Registers third-party dependencies that cannot be auto-registered
/// (they don't have injectable constructors we control).
///
/// The two `@preResolve @singleton` entries are the deliberate exception to
/// the lazy-singleton rule: consumers inject them synchronously, so they must
/// be awaited once during `initMicroPackage()` (`@lazySingleton` with
/// `@preResolve` would resolve just as eagerly). Keep this list to values the
/// first frame needs; everything else stays `@lazySingleton`.
@module
abstract class CcSdkDependencies {
  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  /// Centralized provider for device model, moved from infrastructure_module.dart
  @preResolve
  @singleton
  Future<CcDeviceEntity> deviceModel(CcDeviceInfoHelper deviceInfoHelper) =>
      deviceInfoHelper.getDeviceEntity();
}
