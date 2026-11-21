import 'dart:io';

import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:injectable/injectable.dart';

/// [CcDeviceIdProvider] from the platform: `identifierForVendor` on iOS and
/// macOS, the `flutter_udid` UDID elsewhere. Never throws; a failure gives ''.
@LazySingleton(as: CcDeviceIdProvider)
class CcUdidDeviceIdProvider implements CcDeviceIdProvider {
  CcUdidDeviceIdProvider(this._deviceInfo);

  final DeviceInfoPlugin _deviceInfo;

  @override
  Future<String> deviceId() async {
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        return (await _deviceInfo.iosInfo).identifierForVendor ?? '';
      }
      return await FlutterUdid.udid;
    } catch (_) {
      return '';
    }
  }
}
