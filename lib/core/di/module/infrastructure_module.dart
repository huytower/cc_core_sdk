import 'package:cc_sdk/core/helper/device_info_service.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InfrastructureModule {
  @preResolve
  @singleton
  Future<CcDeviceEntity> deviceModel(
    DeviceInfoService deviceInfoService,
  ) =>
      deviceInfoService.getDeviceEntity();
}
