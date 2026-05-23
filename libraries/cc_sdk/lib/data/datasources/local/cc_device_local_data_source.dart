import 'dart:io';

import '../../../core/utils/common/cc_device_info_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../models/cc_device_model.dart';

/// Contract for fetching device info from the local platform.
abstract class CcDeviceLocalDataSource {
  Future<CcDeviceModel> getDeviceInfo();
}

/// Implementation using [DeviceInfoPlugin] and [PackageInfo].
@LazySingleton(as: CcDeviceLocalDataSource)
class CcDeviceLocalDataSourceImpl implements CcDeviceLocalDataSource {
  final DeviceInfoPlugin deviceInfoPlugin;

  const CcDeviceLocalDataSourceImpl({required this.deviceInfoPlugin});

  @override
  Future<CcDeviceModel> getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfoService = CcDeviceInfoService(
      deviceInfoPlugin: deviceInfoPlugin,
    );
    final deviceId = await deviceInfoService.getDeviceId();
    final rawDeviceInfo = await deviceInfoService.getDeviceInfo();

    if (Platform.isAndroid) {
      final android = await deviceInfoPlugin.androidInfo;
      return CcDeviceModel(
        deviceInfo: rawDeviceInfo,
        deviceName: android.device,
        deviceId: deviceId,
        osName: 'Android',
        osVersion: android.version.release,
        appName: packageInfo.appName,
        appVersion: packageInfo.version,
        packageName: packageInfo.packageName,
        model: android.model,
        brand: android.brand,
        isPhysicalDevice: android.isPhysicalDevice,
      );
    } else if (Platform.isIOS) {
      final ios = await deviceInfoPlugin.iosInfo;
      return CcDeviceModel(
        deviceInfo: rawDeviceInfo,
        deviceName: ios.name,
        deviceId: deviceId,
        osName: 'iOS',
        osVersion: ios.systemVersion,
        appName: packageInfo.appName,
        appVersion: packageInfo.version,
        packageName: packageInfo.packageName,
        model: ios.model,
        brand: 'Apple',
        isPhysicalDevice: ios.isPhysicalDevice,
      );
    } else {
      return CcDeviceModel(
        deviceInfo: rawDeviceInfo,
        deviceId: deviceId,
        appName: packageInfo.appName,
        appVersion: packageInfo.version,
        packageName: packageInfo.packageName,
      );
    }
  }
}
