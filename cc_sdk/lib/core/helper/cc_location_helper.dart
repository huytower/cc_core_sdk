import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CcLocationHelper {
  static const String defaultCountryCode = '+84'; // Vietnam

  /// Mapping of ISO country codes to phone calling codes
  static const Map<String, String> countryPhoneCodes = {
    'VN': '+84',
    'US': '+1',
    'BE': '+32',
    'GB': '+44',
    'FR': '+33',
    'DE': '+49',
    'JP': '+81',
    'CN': '+86',
    'KR': '+82',
    'SG': '+65',
    'TH': '+66',
    'MY': '+60',
    'ID': '+62',
    'PH': '+63',
    'AU': '+61',
  };

  /// Request location permission
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Get current position
  static Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await isLocationPermissionGranted();
      if (!hasPermission) {
        final granted = await requestLocationPermission();
        if (!granted) {
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      return null;
    }
  }

  /// The OS's cached last-known fix, if any — resolves near-instantly since
  /// it doesn't wait for a new GPS lock, at the cost of possibly being stale
  /// or from a different spot than right now. Never prompts for permission
  /// (returns null if not already granted) since this is meant as an
  /// opportunistic fast path alongside a real [getCurrentPosition] call, not
  /// a substitute for it.
  static Future<Position?> getLastKnownPosition() async {
    try {
      final hasPermission = await isLocationPermissionGranted();
      if (!hasPermission) return null;
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  /// Get country code from location
  static Future<String> getCountryCodeFromLocation() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) {
        return defaultCountryCode;
      }

      // Use geocoding to get country from coordinates
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final isoCode = placemarks.first.isoCountryCode;
        if (isoCode != null && countryPhoneCodes.containsKey(isoCode)) {
          return countryPhoneCodes[isoCode]!;
        }
      }

      return defaultCountryCode;
    } catch (e) {
      return defaultCountryCode;
    }
  }

  /// Get country code (with location detection)
  static Future<String> getCountryCode() async {
    try {
      final countryCode = await getCountryCodeFromLocation();
      return countryCode;
    } catch (e) {
      return defaultCountryCode;
    }
  }

  /// Great-circle distance in meters between two coordinates. Thin wrapper
  /// so callers never need a direct `geolocator` dependency of their own.
  static double distanceBetweenMeters(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
