import 'package:app_config/data/datasource/local/box/device_info/cc_device_info.dart';
import 'package:cc_sdk/core/utils/common/device_utils.dart';

import 'device_dimension_manager.dart';
import 'device_info_manager.dart';
import 'device_initialization_error.dart';

/// Coordinates device-related operations
///
/// This class is responsible for initializing device-specific information
/// and managing device-related operations by delegating to specialized managers.
class DeviceInitializer {
  final DeviceInfoManager _infoManager;
  final DeviceDimensionManager _dimensionManager;

  /// Creates a [DeviceInitializer] instance.
  const DeviceInitializer({
    required DeviceInfoManager infoManager,
    required DeviceDimensionManager dimensionManager,
  })  : _infoManager = infoManager,
        _dimensionManager = dimensionManager;

  /// Creates a [DeviceInitializer] instance with default managers.
  ///
  /// [deviceInfo] The device information container
  factory DeviceInitializer.withDefaults({
    required CcDeviceInfo deviceInfo,
  }) {
    return DeviceInitializer(
      infoManager: DeviceInfoManager(deviceInfo),
      dimensionManager: DeviceDimensionManager(deviceInfo),
    );
  }

  /// Gets the device dimension manager
  DeviceDimensionManager get dimensionManager => _dimensionManager;

  /// Gets the device info manager
  DeviceInfoManager get infoManager => _infoManager;

  /// Initializes device-specific information
  ///
  /// Throws [DeviceInitializationError] if initialization fails
  Future<void> initialize() async {
    try {
      final deviceId = await DeviceUtils.getDeviceId();
      final appVersion = await DeviceUtils.getAppVersion();

      _infoManager.updateDeviceInfo(
        deviceId: deviceId,
        appVersion: appVersion,
      );
    } catch (error) {
      throw DeviceInitializationError(
        'Failed to initialize device info: $error',
        error,
      );
    }
  }
}
