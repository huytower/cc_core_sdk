import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_device/export_cc_sdk_device.dart';
import 'package:flutter_test/flutter_test.dart';

// The test host has no location, permission or geocoding plugin, so every
// platform call fails. The service must turn those failures into "no
// permission" / "no position" answers instead of throwing into the caller.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CcLocationService location;

  setUp(() => location = CcDeviceLocationService());

  test('reports no permission when the platform cannot answer', () async {
    expect(await location.hasPermission(), isFalse);
    expect(await location.requestPermission(), isFalse);
  });

  test('concurrent permission requests share one platform request', () {
    final first = location.requestPermission();
    final second = location.requestPermission();

    expect(identical(first, second), isTrue);
  });

  test('returns no position and publishes none', () async {
    expect(await location.getCurrentPosition(), isNull);
    expect(await location.getLastKnownPosition(), isNull);
    expect(location.lastPosition.value, isNull);
  });

  test('returns no country code when geocoding fails', () async {
    final code = await location.countryCodeAt(
      const CcGeoPosition(latitude: 21.03, longitude: 105.85),
    );

    expect(code, isNull);
  });
}
