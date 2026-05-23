import 'package:injectable/injectable.dart';

import '../../../core/helper/device_info_helper.dart';
import '../../../domain/entities/cc_device_entity.dart';

/// Contract for fetching device info from the local platform.
abstract class CcDeviceLocalDataSource {
  Future<CcDeviceEntity> getDeviceInfo();
}

/// Delegates to [DeviceInfoHelper] which reuses the DI-registered
/// [DeviceInfoPlugin] singleton.
@LazySingleton(as: CcDeviceLocalDataSource)
class CcDeviceLocalDataSourceImpl implements CcDeviceLocalDataSource {
  final DeviceInfoHelper deviceInfoHelper;

  const CcDeviceLocalDataSourceImpl({required this.deviceInfoHelper});

  @override
  Future<CcDeviceEntity> getDeviceInfo() => deviceInfoHelper.getDeviceEntity();
}
