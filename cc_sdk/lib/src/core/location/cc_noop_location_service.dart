import 'package:flutter/foundation.dart';

import 'cc_geo_position.dart';
import 'cc_location_service.dart';

/// [CcLocationService] with no location: for tests and apps without it.
class CcNoopLocationService implements CcLocationService {
  CcNoopLocationService();

  final ValueNotifier<CcGeoPosition?> _lastPosition = ValueNotifier(null);

  @override
  ValueListenable<CcGeoPosition?> get lastPosition => _lastPosition;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<bool> hasPermission() async => false;

  @override
  Future<CcGeoPosition?> getCurrentPosition() async => null;

  @override
  Future<CcGeoPosition?> getLastKnownPosition() async => null;

  @override
  Future<String?> countryCodeAt(CcGeoPosition position) async => null;
}

