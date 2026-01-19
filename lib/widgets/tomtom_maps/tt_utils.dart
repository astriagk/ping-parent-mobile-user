import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Utility functions for TomTom Maps
/// Provides distance calculations, bounds handling, and formatting
class TTUtils {
  static const Distance _distance = Distance();

  /// Calculate bounding box from list of points
  static LatLngBounds? calculateBounds(List<LatLng> points) {
    if (points.isEmpty) return null;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    return LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );
  }

  /// Fit map to bounds with padding
  static void fitBounds(
    MapController controller,
    List<LatLng> points, {
    EdgeInsets padding = const EdgeInsets.all(50),
  }) {
    final bounds = calculateBounds(points);
    if (bounds != null) {
      controller.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: padding,
        ),
      );
    }
  }

  /// Calculate center point of multiple locations
  static LatLng calculateCenter(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);
    if (points.length == 1) return points.first;

    double sumLat = 0;
    double sumLng = 0;

    for (final point in points) {
      sumLat += point.latitude;
      sumLng += point.longitude;
    }

    return LatLng(sumLat / points.length, sumLng / points.length);
  }

  /// Calculate distance between two points in meters
  static double calculateDistance(LatLng start, LatLng end) {
    return _distance.as(LengthUnit.Meter, start, end);
  }

  /// Calculate total distance of a route (list of points) in meters
  static double calculateRouteDistance(List<LatLng> points) {
    if (points.length < 2) return 0;

    double total = 0;
    for (int i = 0; i < points.length - 1; i++) {
      total += calculateDistance(points[i], points[i + 1]);
    }
    return total;
  }

  /// Format distance for display
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    }
    return '${(meters / 1000).toStringAsFixed(2)} km';
  }

  /// Format duration for display
  static String formatDuration(double seconds) {
    final minutes = (seconds / 60).round();
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = (minutes / 60).floor();
    final remainingMinutes = minutes % 60;
    return '$hours hr $remainingMinutes min';
  }

  /// Check if a point is within bounds
  static bool isPointInBounds(LatLng point, LatLngBounds bounds) {
    return bounds.contains(point);
  }

  /// Get appropriate zoom level for a given distance (in meters)
  static double getZoomForDistance(double distanceMeters) {
    if (distanceMeters < 500) return 17;
    if (distanceMeters < 1000) return 16;
    if (distanceMeters < 2000) return 15;
    if (distanceMeters < 5000) return 14;
    if (distanceMeters < 10000) return 13;
    if (distanceMeters < 20000) return 12;
    if (distanceMeters < 50000) return 11;
    if (distanceMeters < 100000) return 10;
    if (distanceMeters < 200000) return 9;
    return 8;
  }

  /// Calculate bearing between two points (in degrees)
  static double calculateBearing(LatLng start, LatLng end) {
    final startLat = start.latitude * (math.pi / 180);
    final startLng = start.longitude * (math.pi / 180);
    final endLat = end.latitude * (math.pi / 180);
    final endLng = end.longitude * (math.pi / 180);

    final dLng = endLng - startLng;

    final x = math.cos(endLat) * math.sin(dLng);
    final y = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(dLng);

    final bearing = math.atan2(x, y);
    return (bearing * (180 / math.pi) + 360) % 360;
  }

  /// Convert bearing to compass direction
  static String bearingToDirection(double bearing) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((bearing + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  /// Calculate destination point given start, bearing, and distance
  static LatLng calculateDestination(
      LatLng start, double bearingDegrees, double distanceMeters) {
    return _distance.offset(start, distanceMeters, bearingDegrees);
  }

  /// Simplify polyline using Douglas-Peucker algorithm
  static List<LatLng> simplifyPolyline(List<LatLng> points,
      {double tolerance = 0.0001}) {
    if (points.length < 3) return points;

    double maxDistance = 0;
    int maxIndex = 0;

    final first = points.first;
    final last = points.last;

    for (int i = 1; i < points.length - 1; i++) {
      final distance = _perpendicularDistance(points[i], first, last);
      if (distance > maxDistance) {
        maxDistance = distance;
        maxIndex = i;
      }
    }

    if (maxDistance > tolerance) {
      final firstHalf =
          simplifyPolyline(points.sublist(0, maxIndex + 1), tolerance: tolerance);
      final secondHalf =
          simplifyPolyline(points.sublist(maxIndex), tolerance: tolerance);

      return [...firstHalf.sublist(0, firstHalf.length - 1), ...secondHalf];
    }

    return [first, last];
  }

  static double _perpendicularDistance(LatLng point, LatLng lineStart, LatLng lineEnd) {
    final dx = lineEnd.longitude - lineStart.longitude;
    final dy = lineEnd.latitude - lineStart.latitude;

    final mag = math.sqrt(dx * dx + dy * dy);
    if (mag == 0) return calculateDistance(point, lineStart);

    final u = ((point.longitude - lineStart.longitude) * dx +
            (point.latitude - lineStart.latitude) * dy) /
        (mag * mag);

    final closestLng = lineStart.longitude + u * dx;
    final closestLat = lineStart.latitude + u * dy;

    return calculateDistance(point, LatLng(closestLat, closestLng));
  }

  /// Check if point is within a circular geofence
  static bool isPointInCircle(
      LatLng point, LatLng center, double radiusMeters) {
    return calculateDistance(point, center) <= radiusMeters;
  }

  /// Check if point is within a polygon
  static bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    if (polygon.length < 3) return false;

    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      if ((polygon[i].latitude > point.latitude) !=
              (polygon[j].latitude > point.latitude) &&
          point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                      (point.latitude - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude) {
        inside = !inside;
      }
      j = i;
    }

    return inside;
  }

  /// Create a bounding box around a center point
  static LatLngBounds createBoundingBox(LatLng center, double radiusMeters) {
    final north = calculateDestination(center, 0, radiusMeters);
    final south = calculateDestination(center, 180, radiusMeters);
    final east = calculateDestination(center, 90, radiusMeters);
    final west = calculateDestination(center, 270, radiusMeters);

    return LatLngBounds(
      LatLng(south.latitude, west.longitude),
      LatLng(north.latitude, east.longitude),
    );
  }

  /// Format speed from m/s to km/h
  static String formatSpeed(double metersPerSecond) {
    final kmh = metersPerSecond * 3.6;
    return '${kmh.toStringAsFixed(1)} km/h';
  }

  /// Calculate estimated time of arrival
  static DateTime calculateETA(double durationSeconds) {
    return DateTime.now().add(Duration(seconds: durationSeconds.round()));
  }

  /// Format ETA for display
  static String formatETA(DateTime eta) {
    final hours = eta.hour.toString().padLeft(2, '0');
    final minutes = eta.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
