import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Registers third-party dependencies that cannot be auto-registered
/// (they don't have injectable constructors we control).
///
/// `SharedPreferences` is the one deliberate `@preResolve @singleton`:
/// consumers inject it synchronously, so it is awaited once during
/// `initMicroPackage()`. Everything else stays `@lazySingleton`, off the boot
/// path. (A device entity is built on demand with
/// `CcDeviceInfoService.getDeviceEntity`, never at boot.)
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
}
