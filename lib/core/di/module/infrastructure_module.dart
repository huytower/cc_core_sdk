import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@module
abstract class InfrastructureModule {
  @singleton
  InternetConnection get connectionChecker => InternetConnection();

  @singleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  @preResolve
  @singleton
  Future<CcDeviceEntity> get deviceModel async {
    final dataSource = CcDeviceLocalDataSourceImpl(
      deviceInfoPlugin: deviceInfoPlugin,
    );
    final model = await dataSource.getDeviceInfo();
    return model.toEntity();
  }
}
