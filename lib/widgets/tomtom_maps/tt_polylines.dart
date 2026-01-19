import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Custom polyline builders for different route types
/// Provides pre-styled polylines for common use cases with TomTom Maps
class TTPolylines {
  /// Default stroke width
  static const double defaultStrokeWidth = 5.0;

  /// Active route polyline (blue, solid)
  static Polyline activeRoute(
    List<LatLng> points, {
    double strokeWidth = defaultStrokeWidth,
    Color? color,
  }) {
    return Polyline(
      points: points,
      strokeWidth: strokeWidth,
      color: color ?? Colors.blue.shade600,
    );
  }

  /// Planned/upcoming route polyline (light blue)
  static Polyline plannedRoute(
    List<LatLng> points, {
    double strokeWidth = defaultStrokeWidth,
    Color? color,
  }) {
    return Polyline(
      points: points,
      strokeWidth: strokeWidth,
      color: color ?? Colors.blue.shade300,
    );
  }

  /// Completed route section (green)
  static Polyline completedRoute(
    List<LatLng> points, {
    double strokeWidth = defaultStrokeWidth,
    Color? color,
  }) {
    return Polyline(
      points: points,
      strokeWidth: strokeWidth,
      color: color ?? Colors.green.shade600,
    );
  }

  /// Alternative route polyline (grey)
  static Polyline alternativeRoute(
    List<LatLng> points, {
    double strokeWidth = defaultStrokeWidth,
    Color? color,
  }) {
    return Polyline(
      points: points,
      strokeWidth: strokeWidth,
      color: color ?? Colors.grey.shade400,
    );
  }

  /// Alert/Traffic route polyline (red)
  static Polyline alertRoute(
    List<LatLng> points, {
    double strokeWidth = defaultStrokeWidth,
    Color? color,
  }) {
    return Polyline(
      points: points,
      strokeWidth: strokeWidth,
      color: color ?? Colors.red.shade600,
    );
  }

  /// Walking route polyline (orange, dashed)
  static Polyline walkingRoute(
    List<LatLng> points, {
    double strokeWidth = 4.0,
    Color? color,
  }) {
    return Polyline(
      points: points,
      strokeWidth: strokeWidth,
      color: color ?? Colors.orange.shade600,
      pattern: const StrokePattern.dotted(),
    );
  }

  /// Custom route polyline with full control
  static Polyline customRoute({
    required List<LatLng> points,
    required Color color,
    double strokeWidth = defaultStrokeWidth,
    StrokePattern pattern = const StrokePattern.solid(),
  }) {
    return Polyline(
      points: points,
      strokeWidth: strokeWidth,
      color: color,
      pattern: pattern,
    );
  }

  /// Route with border (for better visibility)
  static List<Polyline> borderedRoute(
    List<LatLng> points, {
    double strokeWidth = defaultStrokeWidth,
    Color? color,
    Color borderColor = Colors.white,
    double borderWidth = 2.0,
  }) {
    return [
      // Border (rendered first, appears behind)
      Polyline(
        points: points,
        strokeWidth: strokeWidth + borderWidth * 2,
        color: borderColor,
      ),
      // Main route (rendered on top)
      Polyline(
        points: points,
        strokeWidth: strokeWidth,
        color: color ?? Colors.blue.shade600,
      ),
    ];
  }

  /// Gradient-style route (multiple polylines with different colors)
  static List<Polyline> gradientRoute(
    List<LatLng> points, {
    double strokeWidth = defaultStrokeWidth,
    Color startColor = Colors.green,
    Color endColor = Colors.red,
  }) {
    if (points.length < 2) return [];

    final List<Polyline> polylines = [];
    final segmentCount = points.length - 1;

    for (int i = 0; i < segmentCount; i++) {
      final progress = i / segmentCount;
      final color = Color.lerp(startColor, endColor, progress)!;

      polylines.add(Polyline(
        points: [points[i], points[i + 1]],
        strokeWidth: strokeWidth,
        color: color,
      ));
    }

    return polylines;
  }

  /// Progress route showing completed vs remaining sections
  static List<Polyline> progressRoute(
    List<LatLng> points, {
    required int completedIndex,
    double strokeWidth = defaultStrokeWidth,
    Color completedColor = Colors.green,
    Color remainingColor = Colors.blue,
  }) {
    if (points.length < 2 || completedIndex < 0) return [];

    final List<Polyline> polylines = [];
    final clampedIndex = completedIndex.clamp(0, points.length - 1);

    // Completed section
    if (clampedIndex > 0) {
      polylines.add(Polyline(
        points: points.sublist(0, clampedIndex + 1),
        strokeWidth: strokeWidth,
        color: completedColor,
      ));
    }

    // Remaining section
    if (clampedIndex < points.length - 1) {
      polylines.add(Polyline(
        points: points.sublist(clampedIndex),
        strokeWidth: strokeWidth,
        color: remainingColor,
      ));
    }

    return polylines;
  }

  /// Traffic-aware route with color coding
  static List<Polyline> trafficRoute(
    List<LatLng> points,
    List<TTTrafficLevel> trafficLevels, {
    double strokeWidth = defaultStrokeWidth,
  }) {
    if (points.length < 2 || trafficLevels.isEmpty) return [];

    final List<Polyline> polylines = [];
    final segmentCount = points.length - 1;

    for (int i = 0; i < segmentCount && i < trafficLevels.length; i++) {
      polylines.add(Polyline(
        points: [points[i], points[i + 1]],
        strokeWidth: strokeWidth,
        color: trafficLevels[i].color,
      ));
    }

    return polylines;
  }
}

/// Circle markers for zones and geofencing with TomTom Maps
class TTCircles {
  /// Safe zone circle (green)
  static CircleMarker safeZone(
    LatLng center, {
    required double radiusMeters,
    Color? color,
    Color? borderColor,
    double borderWidth = 2.0,
  }) {
    return CircleMarker(
      point: center,
      radius: radiusMeters,
      useRadiusInMeter: true,
      color: color ?? Colors.green.withValues(alpha: 0.2),
      borderColor: borderColor ?? Colors.green.shade700,
      borderStrokeWidth: borderWidth,
    );
  }

  /// Alert zone circle (red)
  static CircleMarker alertZone(
    LatLng center, {
    required double radiusMeters,
    Color? color,
    Color? borderColor,
    double borderWidth = 2.0,
  }) {
    return CircleMarker(
      point: center,
      radius: radiusMeters,
      useRadiusInMeter: true,
      color: color ?? Colors.red.withValues(alpha: 0.2),
      borderColor: borderColor ?? Colors.red.shade700,
      borderStrokeWidth: borderWidth,
    );
  }

  /// Custom zone circle
  static CircleMarker customZone({
    required LatLng center,
    required double radiusMeters,
    required Color color,
    Color? borderColor,
    double borderWidth = 2.0,
  }) {
    return CircleMarker(
      point: center,
      radius: radiusMeters,
      useRadiusInMeter: true,
      color: color.withValues(alpha: 0.2),
      borderColor: borderColor ?? color,
      borderStrokeWidth: borderWidth,
    );
  }

  /// GPS accuracy indicator circle
  static CircleMarker accuracyCircle(
    LatLng center, {
    required double accuracyMeters,
    Color? color,
  }) {
    return CircleMarker(
      point: center,
      radius: accuracyMeters,
      useRadiusInMeter: true,
      color: color ?? Colors.blue.withValues(alpha: 0.15),
      borderColor: Colors.blue.withValues(alpha: 0.3),
      borderStrokeWidth: 1.0,
    );
  }
}

/// Traffic level enum for traffic-aware routing
enum TTTrafficLevel {
  free(Colors.green),
  light(Colors.lightGreen),
  moderate(Colors.yellow),
  heavy(Colors.orange),
  severe(Colors.red);

  final Color color;
  const TTTrafficLevel(this.color);
}
