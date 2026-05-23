import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InfrastructureModule {
  @preResolve
  @singleton
  Future<CcDeviceEntity> deviceModel(DeviceInfoPlugin deviceInfoPlugin) async {
    final dataSource = CcDeviceLocalDataSourceImpl(
      deviceInfoPlugin: deviceInfoPlugin,
    );
    final model = await dataSource.getDeviceInfo();
    return model.toEntity();
  }
}
