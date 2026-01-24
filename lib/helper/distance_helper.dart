import 'dart:math';
import 'dart:ui';

class DistanceHelper {
  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in kilometers
  static double calculateDistanceInKm(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  /// Convert degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Get formatted distance text (e.g., "500 m" or "2.5 km")
  static String getFormattedDistance(
      double lat1, double lon1, double lat2, double lon2) {
    final distance = calculateDistanceInKm(lat1, lon1, lat2, lon2);
    return formatDistance(distance);
  }

  /// Format distance in km to human readable string
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).toStringAsFixed(0)} m';
    } else {
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }

  /// Get color based on distance
  /// <5km default, 5-10km green, 10-25km orange, >25km red
  static Color getDistanceColor(double distanceInKm, Color veryNearColor,
      Color nearColor, Color moderateColor, Color farColor) {
    if (distanceInKm < 5) {
      return veryNearColor; // Default for very close (<5km)
    } else if (distanceInKm <= 10) {
      return nearColor; // Green for close (5-10km)
    } else if (distanceInKm <= 25) {
      return moderateColor; // Orange for moderate (10-25km)
    } else {
      return farColor; // Red for far (>25km)
    }
  }

  /// Get color with alpha based on distance
  /// Used for background colors
  static Color getDistanceColorWithAlpha(
      double distanceInKm,
      Color veryNearColor,
      Color nearColor,
      Color moderateColor,
      Color farColor,
      double alpha) {
    final color = getDistanceColor(
        distanceInKm, veryNearColor, nearColor, moderateColor, farColor);
    return color.withValues(alpha: alpha);
  }
}
