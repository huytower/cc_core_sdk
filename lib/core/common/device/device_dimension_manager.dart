import 'package:app_config/http/device_info/cc_device_info.dart';

/// Handles device dimension management
class DeviceDimensionManager {
  final CcDeviceInfo _deviceInfo;

  /// Creates a [DeviceDimensionManager] instance.
  const DeviceDimensionManager(this._deviceInfo);

  /// Updates the device dimensions
  ///
  /// [height] The height of the device screen
  /// [width] The width of the device screen
  void updateDimensions(double height, double width) {
    _deviceInfo
      ..deviceHeight = height
      ..deviceWidth = width;
  }

  /// Validates if device dimensions are available
  ///
  /// Returns `true` if both height and width are set, `false` otherwise
  bool hasValidDimensions() {
    return _deviceInfo.deviceHeight != null && _deviceInfo.deviceWidth != null;
  }
}
