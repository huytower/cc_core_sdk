import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('distance to itself is zero', () {
    const p = CcGeoPosition(latitude: 10.7769, longitude: 106.7009);
    expect(p.distanceTo(p), 0);
  });

  test('matches the known Hanoi - Ho Chi Minh City distance', () {
    const hanoi = CcGeoPosition(latitude: 21.0285, longitude: 105.8542);
    const hcmc = CcGeoPosition(latitude: 10.7769, longitude: 106.7009);

    // Same value as geolocator's `distanceBetween` (same haversine, same
    // 6378137 m radius), so callers moved off the plugin see no change.
    expect(hanoi.distanceTo(hcmc), closeTo(1144785.4, 0.1));
    expect(hcmc.distanceTo(hanoi), hanoi.distanceTo(hcmc));
  });

  test('short distances are accurate to the meter', () {
    // 0.001 degree of latitude ~ 111.3 m with this radius.
    expect(
      CcGeoPosition.distanceBetweenMeters(10, 106, 10.001, 106),
      closeTo(111.3, 0.5),
    );
  });
}
