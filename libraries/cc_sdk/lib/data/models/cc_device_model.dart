import '../../domain/entities/cc_device_entity.dart';

/// Data Transfer Object (DTO) for Device information.
///
/// This class handles data mapping and serialization.
class CcDeviceModel {
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

  /// Maps the DTO to a pure Domain Entity.
  CcDeviceEntity toEntity() => CcDeviceEntity(
    deviceInfo: deviceInfo,
    deviceName: deviceName,
    deviceId: deviceId,
    osName: osName,
    osVersion: osVersion,
    appName: appName,
    appVersion: appVersion,
    packageName: packageName,
    model: model,
    brand: brand,
    isPhysicalDevice: isPhysicalDevice,
  );

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
