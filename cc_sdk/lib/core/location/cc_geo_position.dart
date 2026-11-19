import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// A point on Earth (WGS84 degrees), independent of any location plugin.
@immutable
class CcGeoPosition {
  const CcGeoPosition({
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
    this.timestamp,
  });

  final double latitude;
  final double longitude;

  /// Horizontal accuracy radius, when the source reports it.
  final double? accuracyMeters;

  /// When the fix was taken, when the source reports it.
  final DateTime? timestamp;

  /// Same radius as the common location plugins use, so distances match.
  static const double _earthRadiusMeters = 6378137;

  /// Great-circle (haversine) distance in meters to [other].
  double distanceTo(CcGeoPosition other) => distanceBetweenMeters(
    latitude,
    longitude,
    other.latitude,
    other.longitude,
  );

  /// Great-circle (haversine) distance in meters between two coordinates.
  static double distanceBetweenMeters(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    double radians(double degrees) => degrees * math.pi / 180;
    final dLat = radians(endLatitude - startLatitude);
    final dLon = radians(endLongitude - startLongitude);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.pow(math.sin(dLon / 2), 2) *
            math.cos(radians(startLatitude)) *
            math.cos(radians(endLatitude));
    return _earthRadiusMeters * 2 * math.asin(math.sqrt(a));
  }

  @override
  bool operator ==(Object other) =>
      other is CcGeoPosition &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.accuracyMeters == accuracyMeters &&
      other.timestamp == timestamp;

  @override
  int get hashCode =>
      Object.hash(latitude, longitude, accuracyMeters, timestamp);

  @override
  String toString() => 'CcGeoPosition($latitude, $longitude)';
}
