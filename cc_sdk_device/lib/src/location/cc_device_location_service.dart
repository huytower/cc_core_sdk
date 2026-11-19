import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

/// [CcLocationService] backed by `geolocator` (fixes), `geocoding` (reverse
/// geocoding) and `permission_handler` (the location permission).
@LazySingleton(as: CcLocationService)
class CcDeviceLocationService implements CcLocationService {
  final ValueNotifier<CcGeoPosition?> _lastPosition = ValueNotifier(null);
  Future<bool>? _pendingPermissionRequest;

  static const String _tag = 'CcDeviceLocationService';

  @override
  ValueListenable<CcGeoPosition?> get lastPosition => _lastPosition;

  @override
  Future<bool> requestPermission() =>
      _pendingPermissionRequest ??= _requestPermission().whenComplete(
        () => _pendingPermissionRequest = null,
      );

  Future<bool> _requestPermission() async {
    try {
      return (await Permission.location.request()).isGranted;
    } catch (e) {
      'Permission request failed: $e'.Log(_tag);
      return false;
    }
  }

  @override
  Future<bool> hasPermission() async {
    try {
      return (await Permission.location.status).isGranted;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<CcGeoPosition?> getCurrentPosition() async {
    try {
      final status = await Permission.location.status;
      if (status.isPermanentlyDenied || status.isRestricted) return null;
      if (!status.isGranted && !await requestPermission()) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return _publish(position);
    } catch (e) {
      'getCurrentPosition failed: $e'.Log(_tag);
      return null;
    }
  }

  @override
  Future<CcGeoPosition?> getLastKnownPosition() async {
    try {
      if (!await hasPermission()) return null;
      final position = await Geolocator.getLastKnownPosition();
      return position == null ? null : _publish(position);
    } catch (e) {
      'getLastKnownPosition failed: $e'.Log(_tag);
      return null;
    }
  }

  @override
  Future<String?> countryCodeAt(CcGeoPosition position) async {
    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final code = placemarks.isEmpty ? null : placemarks.first.isoCountryCode;
      return code == null || code.isEmpty ? null : code.toUpperCase();
    } catch (e) {
      'Reverse geocoding failed: $e'.Log(_tag);
      return null;
    }
  }

  CcGeoPosition _publish(Position position) {
    final geo = CcGeoPosition(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyMeters: position.accuracy,
      timestamp: position.timestamp,
    );
    _lastPosition.value = geo;
    return geo;
  }
}
