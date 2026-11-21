import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_device/export_cc_sdk_device.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('gives an empty id instead of throwing when no platform answers', () async {
    // The test host has no UDID / device-info plugin, so every lookup fails.
    final CcDeviceIdProvider provider = CcUdidDeviceIdProvider(
      DeviceInfoPlugin(),
    );

    expect(await provider.deviceId(), '');
  });
}
