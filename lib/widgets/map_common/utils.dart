import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Generic map utility functions for all map providers
class MapUtils {
  /// Earth radius in meters
  static const double earthRadius = 6371000;

  // ============ BOUNDS & FITTING ============

  /// Calculate bounds from a list of points
  static LatLngBounds calculateBounds(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLngBounds(const LatLng(0, 0), const LatLng(0, 0));
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );
  }

  /// Fit map to show all points with padding
  static void fitBounds(
    MapController controller,
    List<LatLng> points, {
    EdgeInsets padding = const EdgeInsets.all(50),
  }) {
    if (points.isEmpty) return;

    controller.fitCamera(
      CameraFit.bounds(
        bounds: calculateBounds(points),
        padding: padding,
      ),
    );
  }

  /// Create a bounding box around a center point
  static LatLngBounds createBoundingBox(LatLng center, double radiusMeters) {
    LatLng ne = calculateDestination(center, radiusMeters * sqrt(2), 45);
    LatLng sw = calculateDestination(center, radiusMeters * sqrt(2), 225);
    return LatLngBounds(sw, ne);
  }

  // ============ DISTANCE & CALCULATION ============

  /// Calculate center point of multiple locations
  static LatLng calculateCenter(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);

    double totalLat = 0;
    double totalLng = 0;

    for (var point in points) {
      totalLat += point.latitude;
      totalLng += point.longitude;
    }

    return LatLng(
      totalLat / points.length,
      totalLng / points.length,
    );
  }

  /// Calculate distance between two points in meters (Haversine formula)
  static double calculateDistance(LatLng point1, LatLng point2) {
    double lat1 = point1.latitude * (pi / 180);
    double lat2 = point2.latitude * (pi / 180);
    double deltaLat = (point2.latitude - point1.latitude) * (pi / 180);
    double deltaLng = (point2.longitude - point1.longitude) * (pi / 180);

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  /// Calculate total route distance from a list of points
  static double calculateRouteDistance(List<LatLng> points) {
    if (points.length < 2) return 0;

    double totalDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += calculateDistance(points[i], points[i + 1]);
    }
    return totalDistance;
  }

  /// Calculate bearing between two points (in degrees)
  static double calculateBearing(LatLng from, LatLng to) {
    double lat1 = from.latitude * (pi / 180);
    double lat2 = to.latitude * (pi / 180);
    double deltaLng = (to.longitude - from.longitude) * (pi / 180);

    double y = sin(deltaLng) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLng);

    double bearing = atan2(y, x) * (180 / pi);
    return (bearing + 360) % 360;
  }

  /// Calculate point at distance and bearing from origin
  static LatLng calculateDestination(
    LatLng origin,
    double distanceMeters,
    double bearingDegrees,
  ) {
    double lat1 = origin.latitude * (pi / 180);
    double lng1 = origin.longitude * (pi / 180);
    double bearing = bearingDegrees * (pi / 180);
    double angularDistance = distanceMeters / earthRadius;

    double lat2 = asin(
      sin(lat1) * cos(angularDistance) +
          cos(lat1) * sin(angularDistance) * cos(bearing),
    );

    double lng2 = lng1 +
        atan2(
          sin(bearing) * sin(angularDistance) * cos(lat1),
          cos(angularDistance) - sin(lat1) * sin(lat2),
        );

    return LatLng(lat2 * (180 / pi), lng2 * (180 / pi));
  }

  // ============ FORMATTING ============

  /// Format distance for display
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else if (meters < 10000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  /// Format duration for display
  static String formatDuration(double seconds) {
    if (seconds < 60) {
      return '${seconds.toStringAsFixed(0)} sec';
    } else if (seconds < 3600) {
      return '${(seconds / 60).toStringAsFixed(0)} min';
    } else {
      int hours = (seconds / 3600).floor();
      int minutes = ((seconds % 3600) / 60).floor();
      return '$hours hr $minutes min';
    }
  }

  /// Format speed for display (m/s to km/h)
  static String formatSpeed(double metersPerSecond) {
    double kmh = metersPerSecond * 3.6;
    return '${kmh.toStringAsFixed(1)} km/h';
  }

  /// Get compass direction from bearing
  static String bearingToDirection(double bearing) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    int index = ((bearing + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  // ============ POINT CHECKING ============

  /// Check if point is within bounds
  static bool isPointInBounds(LatLng point, LatLngBounds bounds) {
    return point.latitude >= bounds.south &&
        point.latitude <= bounds.north &&
        point.longitude >= bounds.west &&
        point.longitude <= bounds.east;
  }

  /// Check if a point is within a circle
  static bool isPointInCircle(LatLng point, LatLng center, double radiusMeters) {
    return calculateDistance(point, center) <= radiusMeters;
  }

  /// Check if a point is within a polygon
  static bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    if (polygon.length < 3) return false;

    int intersections = 0;
    int n = polygon.length;

    for (int i = 0; i < n; i++) {
      LatLng v1 = polygon[i];
      LatLng v2 = polygon[(i + 1) % n];

      if (_rayIntersectsSegment(point, v1, v2)) {
        intersections++;
      }
    }

    return intersections % 2 == 1;
  }

  static bool _rayIntersectsSegment(LatLng point, LatLng v1, LatLng v2) {
    if (v1.latitude > v2.latitude) {
      LatLng temp = v1;
      v1 = v2;
      v2 = temp;
    }

    if (point.latitude == v1.latitude || point.latitude == v2.latitude) {
      return _rayIntersectsSegment(
        LatLng(point.latitude + 0.00001, point.longitude),
        v1,
        v2,
      );
    }

    if (point.latitude > v2.latitude || point.latitude < v1.latitude) {
      return false;
    }

    if (point.longitude >= max(v1.longitude, v2.longitude)) {
      return false;
    }

    if (point.longitude < min(v1.longitude, v2.longitude)) {
      return true;
    }

    double slope = (v2.longitude - v1.longitude) / (v2.latitude - v1.latitude);
    double intersectLng = v1.longitude + (point.latitude - v1.latitude) * slope;

    return point.longitude < intersectLng;
  }

  // ============ ZOOM HELPERS ============

  /// Get appropriate zoom level to fit a distance
  static double getZoomForDistance(double distanceInMeters) {
    if (distanceInMeters < 100) return 18.0;
    if (distanceInMeters < 500) return 17.0;
    if (distanceInMeters < 1000) return 16.0;
    if (distanceInMeters < 2000) return 15.0;
    if (distanceInMeters < 5000) return 14.0;
    if (distanceInMeters < 10000) return 13.0;
    if (distanceInMeters < 20000) return 12.0;
    if (distanceInMeters < 50000) return 11.0;
    if (distanceInMeters < 100000) return 10.0;
    return 9.0;
  }

  // ============ POLYLINE HELPERS ============

  /// Simplify a polyline using Douglas-Peucker algorithm
  /// tolerance is in meters
  static List<LatLng> simplifyPolyline(List<LatLng> points, double tolerance) {
    if (points.length <= 2) return points;

    double maxDistance = 0;
    int maxIndex = 0;

    for (int i = 1; i < points.length - 1; i++) {
      double distance = _perpendicularDistance(
        points[i],
        points.first,
        points.last,
      );
      if (distance > maxDistance) {
        maxDistance = distance;
        maxIndex = i;
      }
    }

    if (maxDistance > tolerance) {
      List<LatLng> left = simplifyPolyline(
        points.sublist(0, maxIndex + 1),
        tolerance,
      );
      List<LatLng> right = simplifyPolyline(
        points.sublist(maxIndex),
        tolerance,
      );

      return [...left.sublist(0, left.length - 1), ...right];
    } else {
      return [points.first, points.last];
    }
  }

  static double _perpendicularDistance(LatLng point, LatLng lineStart, LatLng lineEnd) {
    double dx = lineEnd.longitude - lineStart.longitude;
    double dy = lineEnd.latitude - lineStart.latitude;

    double lengthSquared = dx * dx + dy * dy;
    if (lengthSquared == 0) {
      return calculateDistance(point, lineStart);
    }

    double t = max(
      0,
      min(
        1,
        ((point.longitude - lineStart.longitude) * dx +
                (point.latitude - lineStart.latitude) * dy) /
            lengthSquared,
      ),
    );

    LatLng projection = LatLng(
      lineStart.latitude + t * dy,
      lineStart.longitude + t * dx,
    );

    return calculateDistance(point, projection);
  }

  /// Decode Google polyline encoding
  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;

      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}
