import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Map utility functions
class MapUtils {
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

  /// Fit map to show all markers with padding
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

  /// Calculate distance between two points in meters
  static double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // meters

    double lat1 = point1.latitude * (pi / 180);
    double lat2 = point2.latitude * (pi / 180);
    double deltaLat = (point2.latitude - point1.latitude) * (pi / 180);
    double deltaLng = (point2.longitude - point1.longitude) * (pi / 180);

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  /// Calculate total route distance
  static double calculateRouteDistance(List<LatLng> points) {
    if (points.length < 2) return 0;

    double totalDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += calculateDistance(points[i], points[i + 1]);
    }
    return totalDistance;
  }

  /// Format distance for display
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(2)} km';
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

  /// Check if point is within bounds
  static bool isPointInBounds(LatLng point, LatLngBounds bounds) {
    return point.latitude >= bounds.south &&
        point.latitude <= bounds.north &&
        point.longitude >= bounds.west &&
        point.longitude <= bounds.east;
  }

  /// Get zoom level to fit distance
  static double getZoomForDistance(double distanceInMeters) {
    // Approximate zoom levels based on distance
    if (distanceInMeters < 500) return 17.0;
    if (distanceInMeters < 1000) return 16.0;
    if (distanceInMeters < 2000) return 15.0;
    if (distanceInMeters < 5000) return 14.0;
    if (distanceInMeters < 10000) return 13.0;
    if (distanceInMeters < 20000) return 12.0;
    return 11.0;
  }
}
