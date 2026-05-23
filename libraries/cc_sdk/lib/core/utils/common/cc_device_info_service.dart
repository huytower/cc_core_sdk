import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service dedicated to device identity, device metadata, and platform info.
///
/// This service prefers one shared [DeviceInfoPlugin] instance and keeps
/// all device-info logic separate from screen/layout helpers.
class CcDeviceInfoService {
  final DeviceInfoPlugin deviceInfoPlugin;

  CcDeviceInfoService({DeviceInfoPlugin? deviceInfoPlugin})
      : deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  /// Returns a unique device identifier.
  Future<String> getDeviceId() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? '';
    }
    return getDeviceAndroidId();
  }

  /// Returns the Android device identifier via flutter_udid.
  Future<String> getDeviceAndroidId() async {
    return FlutterUdid.udid;
  }

  /// Returns a raw device information JSON string.
  Future<String> getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    var uri = '';
    var osName = '';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      final String androidId = await getDeviceAndroidId();
      osName = 'ANDROID';
      uri =
          '${'${'{"DeviceName":"${androidInfo.device}","DeviceID":"$androidId","OsName":"$osName","OsVersion":"${androidInfo.bootloader}","AppName":"${packageInfo.appName}'}","AppVersion":"${packageInfo.version}'}","UserName":"","LocationInfo":"","Adv":"0"}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      osName = 'iOS';
      uri =
          '${'${'{"DeviceName":"${iosInfo.name}","DeviceID":"${iosInfo.identifierForVendor!}","OsName":"$osName","OsVersion":"${iosInfo.systemVersion}","AppName":"${packageInfo.appName}'}","AppVersion":"${packageInfo.version}'}","UserName":"","LocationInfo":"","Adv":"0"}';
    } else {
      osName = 'other';
    }

    return uri;
  }

  /// Returns whether the current locale is Vietnamese.
  bool isVietnameseLocale() => Platform.localeName.contains('VN');

  /// Returns the application version and build number.
  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid || Platform.isIOS) {
      return '${packageInfo.version}(code: ${packageInfo.buildNumber})';
    }
    return 'unknown';
  }

  /// Returns whether the iOS device version is above 10.5.
  Future<bool> getDeviceVersion() async {
    try {
      if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        final version = double.parse(
          iosInfo.utsname.machine.split('iPhone')[1],
        );
        return version > 10.5;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
