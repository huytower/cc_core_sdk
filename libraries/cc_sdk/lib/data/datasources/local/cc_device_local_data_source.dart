import 'package:injectable/injectable.dart';

import '../../../core/utils/common/cc_device_info_service.dart';
import '../../../domain/entities/cc_device_entity.dart';

/// Contract for fetching device info from the local platform.
abstract class CcDeviceLocalDataSource {
  Future<CcDeviceEntity> getDeviceInfo();
}

/// Delegates to [CcDeviceInfoService] which reuses the DI-registered
/// [DeviceInfoPlugin] singleton.
@LazySingleton(as: CcDeviceLocalDataSource)
class CcDeviceLocalDataSourceImpl implements CcDeviceLocalDataSource {
  final CcDeviceInfoService deviceInfoService;

  const CcDeviceLocalDataSourceImpl({required this.deviceInfoService});

  @override
  Future<CcDeviceEntity> getDeviceInfo() => deviceInfoService.getDeviceEntity();
}
