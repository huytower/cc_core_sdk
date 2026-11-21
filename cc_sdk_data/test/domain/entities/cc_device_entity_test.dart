import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CcDeviceEntity', () {
    test('only deviceInfo is required', () {
      const device = CcDeviceEntity(deviceInfo: 'info');

      expect(device.deviceInfo, 'info');
      expect(device.deviceId, isNull);
      expect(device.isPhysicalDevice, isNull);
    });

    test('compares by value', () {
      const a = CcDeviceEntity(deviceInfo: 'info', deviceId: 'id-1');
      const b = CcDeviceEntity(deviceInfo: 'info', deviceId: 'id-1');
      const c = CcDeviceEntity(deviceInfo: 'info', deviceId: 'id-2');

      expect(a, b);
      expect(a, isNot(c));
    });
  });
}
