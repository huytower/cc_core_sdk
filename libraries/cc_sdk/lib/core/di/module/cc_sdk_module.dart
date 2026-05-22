import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../data/datasources/local/cc_device_local_data_source.dart';
import '../../helper/cc_network_helper.dart';
import '../../network/network_info.dart';

@module
abstract class CcSdkModule {
  @singleton
  InternetConnection get internetConnection => InternetConnection();

  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  @singleton
  CcNetworkHelper networkHelper(InternetConnection connection) =>
      CcNetworkHelper(connection);

  @singleton
  NetworkInfo networkInfo(Connectivity connectivity) =>
      NetworkInfoImpl(connectivity);

  @lazySingleton
  CcDeviceLocalDataSource deviceLocalDataSource(
    DeviceInfoPlugin deviceInfoPlugin,
  ) =>
      CcDeviceLocalDataSourceImpl(deviceInfoPlugin: deviceInfoPlugin);
}
