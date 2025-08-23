import 'package:app_config/config/device_info/cc_device_info.dart';

/// Handles device information management
class DeviceInfoManager {
  final CcDeviceInfo _deviceInfo;

  /// Creates a [DeviceInfoManager] instance.
  const DeviceInfoManager(this._deviceInfo);

  /// Gets the current device ID
  String? get deviceId => _deviceInfo.deviceId;

  /// Gets the current app version
  String? get appVersion => _deviceInfo.appVersion;

  /// Updates the device information
  ///
  /// [deviceId] The unique device identifier
  /// [appVersion] The current app version
  void updateDeviceInfo({
    required String deviceId,
    required String appVersion,
  }) {
    _deviceInfo
      ..deviceId = deviceId
      ..appVersion = appVersion;
  }
}
