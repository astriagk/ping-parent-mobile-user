import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Route polyline styles for different use cases
/// Provides pre-styled polylines for routes, paths, and zones
class OFMPolylines {
  /// Default stroke width
  static const double defaultStrokeWidth = 4.0;

  /// Active/Current route (solid blue line)
  static Polyline activeRoute(
    List<LatLng> points, {
    Color? color,
    double strokeWidth = defaultStrokeWidth,
  }) {
    return Polyline(
      points: points,
      color: color ?? Colors.blue.shade600,
      strokeWidth: strokeWidth,
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
    );
  }

  /// Planned/Upcoming route (lighter blue line)
  static Polyline plannedRoute(
    List<LatLng> points, {
    Color? color,
    double strokeWidth = 3.0,
  }) {
    return Polyline(
      points: points,
      color: color ?? Colors.blue.shade300,
      strokeWidth: strokeWidth,
      strokeCap: StrokeCap.round,
    );
  }

  /// Completed route (solid green line)
  static Polyline completedRoute(
    List<LatLng> points, {
    Color? color,
    double strokeWidth = defaultStrokeWidth,
  }) {
    return Polyline(
      points: points,
      color: color ?? Colors.green.shade600,
      strokeWidth: strokeWidth,
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
    );
  }

  /// Alternative route (grey line)
  static Polyline alternativeRoute(
    List<LatLng> points, {
    Color? color,
    double strokeWidth = 3.0,
  }) {
    return Polyline(
      points: points,
      color: color ?? Colors.grey.shade400,
      strokeWidth: strokeWidth,
      strokeCap: StrokeCap.round,
    );
  }

  /// Alert/Danger route (solid red line)
  static Polyline alertRoute(
    List<LatLng> points, {
    Color? color,
    double strokeWidth = defaultStrokeWidth,
  }) {
    return Polyline(
      points: points,
      color: color ?? Colors.red.shade600,
      strokeWidth: strokeWidth,
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
    );
  }

  /// Walking route (orange line)
  static Polyline walkingRoute(
    List<LatLng> points, {
    Color? color,
    double strokeWidth = 3.0,
  }) {
    return Polyline(
      points: points,
      color: color ?? Colors.orange.shade600,
      strokeWidth: strokeWidth,
      strokeCap: StrokeCap.round,
    );
  }

  /// Custom route with specified parameters
  static Polyline customRoute({
    required List<LatLng> points,
    required Color color,
    double strokeWidth = defaultStrokeWidth,
    StrokeCap strokeCap = StrokeCap.round,
    StrokeJoin strokeJoin = StrokeJoin.round,
    double? borderStrokeWidth,
    Color? borderColor,
  }) {
    return Polyline(
      points: points,
      color: color,
      strokeWidth: strokeWidth,
      strokeCap: strokeCap,
      strokeJoin: strokeJoin,
      borderStrokeWidth: borderStrokeWidth ?? 0,
      borderColor: borderColor ?? Colors.transparent,
    );
  }

  /// Route with border (highlighted route)
  static List<Polyline> borderedRoute(
    List<LatLng> points, {
    Color color = Colors.blue,
    Color borderColor = Colors.white,
    double strokeWidth = 4.0,
    double borderWidth = 2.0,
  }) {
    return [
      // Border (wider, behind)
      Polyline(
        points: points,
        color: borderColor,
        strokeWidth: strokeWidth + (borderWidth * 2),
        strokeCap: StrokeCap.round,
        strokeJoin: StrokeJoin.round,
      ),
      // Main line (on top)
      Polyline(
        points: points,
        color: color,
        strokeWidth: strokeWidth,
        strokeCap: StrokeCap.round,
        strokeJoin: StrokeJoin.round,
      ),
    ];
  }

  /// Multi-segment route with gradient colors
  /// Creates visual progress indication along the route
  static List<Polyline> gradientRoute(
    List<LatLng> points, {
    Color startColor = Colors.green,
    Color endColor = Colors.red,
    int segments = 10,
    double strokeWidth = defaultStrokeWidth,
  }) {
    if (points.length < 2) return [];

    List<Polyline> polylines = [];
    int pointsPerSegment = (points.length / segments).ceil();

    for (int i = 0; i < segments; i++) {
      int start = i * pointsPerSegment;
      int end = ((i + 1) * pointsPerSegment).clamp(0, points.length);

      if (start >= points.length) break;

      // Include overlap point for continuous line
      if (start > 0) start--;

      double ratio = i / (segments - 1);
      Color segmentColor = Color.lerp(startColor, endColor, ratio)!;

      polylines.add(
        Polyline(
          points: points.sublist(start, end),
          color: segmentColor,
          strokeWidth: strokeWidth,
          strokeCap: StrokeCap.round,
          strokeJoin: StrokeJoin.round,
        ),
      );
    }

    return polylines;
  }

  /// Progress route showing completed vs remaining
  static List<Polyline> progressRoute(
    List<LatLng> points, {
    required int progressIndex,
    Color completedColor = Colors.green,
    Color remainingColor = Colors.grey,
    double strokeWidth = defaultStrokeWidth,
  }) {
    if (points.length < 2 || progressIndex < 0) return [];

    final clampedIndex = progressIndex.clamp(0, points.length - 1);

    return [
      // Completed portion
      if (clampedIndex > 0)
        Polyline(
          points: points.sublist(0, clampedIndex + 1),
          color: completedColor,
          strokeWidth: strokeWidth,
          strokeCap: StrokeCap.round,
          strokeJoin: StrokeJoin.round,
        ),
      // Remaining portion
      if (clampedIndex < points.length - 1)
        Polyline(
          points: points.sublist(clampedIndex),
          color: remainingColor.withValues(alpha: 0.5),
          strokeWidth: strokeWidth - 1,
          strokeCap: StrokeCap.round,
        ),
    ];
  }

}

/// Circle/Zone overlays for geofencing and areas
class OFMCircles {
  /// Safe zone circle (green)
  static CircleMarker safeZone(
    LatLng center, {
    double radius = 500,
    Color? color,
    Color? borderColor,
  }) {
    return CircleMarker(
      point: center,
      radius: radius,
      color: color ?? Colors.green.withValues(alpha: 0.2),
      borderColor: borderColor ?? Colors.green,
      borderStrokeWidth: 2,
      useRadiusInMeter: true,
    );
  }

  /// Alert zone circle (red)
  static CircleMarker alertZone(
    LatLng center, {
    double radius = 500,
    Color? color,
    Color? borderColor,
  }) {
    return CircleMarker(
      point: center,
      radius: radius,
      color: color ?? Colors.red.withValues(alpha: 0.2),
      borderColor: borderColor ?? Colors.red,
      borderStrokeWidth: 2,
      useRadiusInMeter: true,
    );
  }

  /// Custom zone circle
  static CircleMarker customZone({
    required LatLng center,
    required double radius,
    required Color color,
    Color? borderColor,
    double borderWidth = 2,
    bool useMeters = true,
  }) {
    return CircleMarker(
      point: center,
      radius: radius,
      color: color.withValues(alpha: 0.2),
      borderColor: borderColor ?? color,
      borderStrokeWidth: borderWidth,
      useRadiusInMeter: useMeters,
    );
  }

  /// Accuracy circle for GPS position
  static CircleMarker accuracyCircle(
    LatLng center, {
    required double accuracyMeters,
    Color color = Colors.blue,
  }) {
    return CircleMarker(
      point: center,
      radius: accuracyMeters,
      color: color.withValues(alpha: 0.1),
      borderColor: color.withValues(alpha: 0.3),
      borderStrokeWidth: 1,
      useRadiusInMeter: true,
    );
  }
}
