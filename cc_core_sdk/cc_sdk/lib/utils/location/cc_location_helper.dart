import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CcLocationHelper {
  static const String defaultCountryCode = '+84'; // Vietnam

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

  /// Get country code from location
  static Future<String> getCountryCodeFromLocation() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) {
        return defaultCountryCode;
      }

      // Use geocoding to get country from coordinates
      // For now, return default country code
      // TODO: Implement geocoding to get actual country code
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
}
