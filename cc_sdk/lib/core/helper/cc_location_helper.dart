import 'package:cc_sdk/core/extensions/common/cc_logger_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CcLocationHelper {
  static const String defaultCountryCode = '+84'; // Vietnam

  /// Reactive ValueNotifier holding the latest GPS position obtained by the device.
  static final ValueNotifier<Position?> lastGpsPosition =
      ValueNotifier<Position?>(null);

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

  static Future<bool>? _permissionRequestFuture;

  /// Request location permission (deduplicated across concurrent calls)
  static Future<bool> requestLocationPermission() {
    if (_permissionRequestFuture != null) {
      '[CcLocationHelper] Permission request already in flight. Reusing active request.'
          .Log('CcLocationHelper');
      return _permissionRequestFuture!;
    }
    _permissionRequestFuture = _doRequestLocationPermission().whenComplete(() {
      _permissionRequestFuture = null;
    });
    return _permissionRequestFuture!;
  }

  static Future<bool> _doRequestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      '[CcLocationHelper] Location permission result: $status'.Log(
        'CcLocationHelper',
      );
      return status.isGranted;
    } catch (e) {
      '[CcLocationHelper] Location permission request error: $e'.Log(
        'CcLocationHelper',
      );
      return false;
    }
  }

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Get current position
  static Future<Position?> getCurrentPosition() async {
    try {
      final status = await Permission.location.status;
      if (status.isPermanentlyDenied || status.isRestricted) {
        '[CcLocationHelper] Location permission permanently denied ($status) | skipping request'
            .Log('CcLocationHelper');
        return null;
      }

      if (!status.isGranted) {
        final granted = await requestLocationPermission();
        if (!granted) {
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      '[CcLocationHelper] GPS position obtained: lat=${position.latitude}, lng=${position.longitude}'
          .Log('CcLocationHelper');
      lastGpsPosition.value = position;
      return position;
    } catch (e) {
      '[CcLocationHelper] Error getting GPS position: $e'.Log(
        'CcLocationHelper',
      );
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
      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        '[CcLocationHelper] Last known GPS position: lat=${position.latitude}, lng=${position.longitude}'
            .Log('CcLocationHelper');
        lastGpsPosition.value = position;
      }
      return position;
    } catch (e) {
      '[CcLocationHelper] Error getting last known position: $e'.Log(
        'CcLocationHelper',
      );
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
      final List<Placemark> placemarks = await Geocoding()
          .placemarkFromCoordinates(position.latitude, position.longitude);

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
