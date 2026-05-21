import 'package:equatable/equatable.dart';

/// Represents the device information for tracking and logging.
class CcDeviceModel extends Equatable {
  final String? deviceName;
  final String? deviceId;
  final String? osName;
  final String? osVersion;
  final String? appName;
  final String? appVersion;
  final String? packageName;
  final String? model;
  final String? brand;
  final bool? isPhysicalDevice;

  /// The raw device info string for backward compatibility or quick logging.
  final String deviceInfo;

  const CcDeviceModel({
    required this.deviceInfo,
    this.deviceName,
    this.deviceId,
    this.osName,
    this.osVersion,
    this.appName,
    this.appVersion,
    this.packageName,
    this.model,
    this.brand,
    this.isPhysicalDevice,
  });

  @override
  List<Object?> get props => [
    deviceInfo,
    deviceName,
    deviceId,
    osName,
    osVersion,
    appName,
    appVersion,
    packageName,
    model,
    brand,
    isPhysicalDevice,
  ];

  Map<String, dynamic> toMap() {
    return {
      'deviceInfo': deviceInfo,
      'deviceName': deviceName,
      'deviceId': deviceId,
      'osName': osName,
      'osVersion': osVersion,
      'appName': appName,
      'appVersion': appVersion,
      'packageName': packageName,
      'model': model,
      'brand': brand,
      'isPhysicalDevice': isPhysicalDevice,
    };
  }
}
