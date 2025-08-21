import 'package:app_config/config/device_info/cc_device_info.dart';
import 'package:cc_library/helper/device_helper.dart';
import 'package:cc_library/util/base_utils.dart';

/// Handles device-related initialization
class DeviceInitializer {
  final CcDeviceInfo deviceInfo;
  final DeviceHelper deviceHelper;
  final BaseUtils baseUtils;

  const DeviceInitializer({
    required this.deviceInfo,
    required this.deviceHelper,
    required this.baseUtils,
  });

  /// Initializes device-specific information
  Future<void> initialize() async {
    deviceInfo
      ..deviceId = await DeviceHelper.getDeviceId()
      ..appVersion = await BaseUtils.getAppVersion();
  }

  /// Updates the device dimensions
  void updateDimensions(double height, double width) {
    deviceInfo
      ..deviceHeight = height
      ..deviceWidth = width;
  }

  /// Validates if device dimensions are available
  bool hasValidDimensions() {
    return deviceInfo.deviceHeight != null && deviceInfo.deviceWidth != null;
  }
}
