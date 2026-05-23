import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Registers third-party dependencies that cannot be auto-registered
/// (they don't have injectable constructors we control).
@module
abstract class CcSdkDependencies {
  @singleton
  InternetConnection get internetConnection => InternetConnection();

  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();
}
