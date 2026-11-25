import 'package:flutter/foundation.dart';

import 'cc_geo_position.dart';

/// Device location and reverse geocoding, independent of any plugin.
///
/// The SDK core only defines this contract. An implementation comes from a
/// capability package (e.g. `CcDeviceLocationService` in `cc_sdk_device`),
/// registered in DI as `CcLocationService`. Methods never throw; a missing
/// permission or fix gives null / false.
///
/// ```dart
/// final here = await location.getCurrentPosition();
/// final country = here == null ? null : await location.countryCodeAt(here);
/// ```
abstract interface class CcLocationService {
  /// The latest fix obtained by [getCurrentPosition] or
  /// [getLastKnownPosition], for listeners that react to a new location.
  ValueListenable<CcGeoPosition?> get lastPosition;

  /// Asks for location permission (concurrent calls share one prompt).
  Future<bool> requestPermission();

  Future<bool> hasPermission();

  /// A fresh fix. Asks for permission if not granted yet; null if denied
  /// (or permanently denied / restricted) or no fix could be taken.
  Future<CcGeoPosition?> getCurrentPosition();

  /// The OS's cached last fix: fast but possibly stale. Never prompts for
  /// permission (null if not granted), so use it alongside
  /// [getCurrentPosition] as a quick first answer, not instead of it.
  Future<CcGeoPosition?> getLastKnownPosition();

  /// ISO 3166-1 alpha-2 country code (upper case, e.g. `VN`) at [position],
  /// by reverse geocoding; null if unknown.
  Future<String?> countryCodeAt(CcGeoPosition position);
}
