import '../../config.dart';

/// Generic polyline builders for all map providers
/// Uses app theme colors for consistent styling
class MapPolylines {
  /// Default stroke width
  static const double defaultStrokeWidth = 4.0;

  /// Active route polyline (uses theme active color)
  static Polyline activeRoute(List<LatLng> points, BuildContext context) {
    final theme = appColor(context).appTheme;
    return Polyline(
      points: points,
      color: theme.activeColor,
      strokeWidth: defaultStrokeWidth,
    );
  }

  /// Planned/upcoming route polyline (uses theme dash color)
  static Polyline plannedRoute(List<LatLng> points, BuildContext context) {
    final theme = appColor(context).appTheme;
    return Polyline(
      points: points,
      color: theme.dashColor,
      strokeWidth: 3.0,
    );
  }

  /// Completed route section (uses theme success color)
  static Polyline completedRoute(List<LatLng> points, BuildContext context) {
    final theme = appColor(context).appTheme;
    return Polyline(
      points: points,
      color: theme.success,
      strokeWidth: 3.0,
    );
  }

  /// Alternative route polyline (uses theme yellow icon color)
  static Polyline alternativeRoute(List<LatLng> points, BuildContext context) {
    final theme = appColor(context).appTheme;
    return Polyline(
      points: points,
      color: theme.yellowIcon,
      strokeWidth: 3.0,
    );
  }

  /// Alert/Traffic route polyline (uses theme alert zone color)
  static Polyline alertRoute(List<LatLng> points, BuildContext context) {
    final theme = appColor(context).appTheme;
    return Polyline(
      points: points,
      color: theme.alertZone,
      strokeWidth: defaultStrokeWidth,
    );
  }

  /// Walking route polyline (dotted pattern)
  static Polyline walkingRoute(List<LatLng> points, BuildContext context) {
    final theme = appColor(context).appTheme;
    return Polyline(
      points: points,
      color: theme.yellowIcon,
      strokeWidth: 3.0,
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
    List<LatLng> points,
    BuildContext context, {
    double strokeWidth = defaultStrokeWidth,
    Color? color,
    Color borderColor = Colors.white,
    double borderWidth = 2.0,
  }) {
    final theme = appColor(context).appTheme;
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
        color: color ?? theme.activeColor,
      ),
    ];
  }

  /// Gradient-style route (multiple polylines with different colors)
  static List<Polyline> gradientRoute(
    List<LatLng> points,
    BuildContext context, {
    double strokeWidth = defaultStrokeWidth,
    Color? startColor,
    Color? endColor,
    int segments = 5,
  }) {
    if (points.length < 2) return [];

    final theme = appColor(context).appTheme;
    final List<Polyline> polylines = [];
    int pointsPerSegment = (points.length / segments).ceil();

    for (int i = 0; i < segments; i++) {
      int start = i * pointsPerSegment;
      int end = ((i + 1) * pointsPerSegment).clamp(0, points.length);

      if (start >= points.length) break;

      double ratio = i / (segments - 1);
      Color segmentColor = Color.lerp(
        startColor ?? theme.success,
        endColor ?? theme.alertZone,
        ratio,
      )!;

      polylines.add(
        Polyline(
          points: points.sublist(start, end),
          color: segmentColor,
          strokeWidth: strokeWidth,
        ),
      );
    }

    return polylines;
  }

  /// Progress route showing completed vs remaining sections
  static List<Polyline> progressRoute(
    List<LatLng> points,
    BuildContext context, {
    required int completedIndex,
    double strokeWidth = defaultStrokeWidth,
  }) {
    if (points.length < 2 || completedIndex < 0) return [];

    final theme = appColor(context).appTheme;
    final List<Polyline> polylines = [];
    final clampedIndex = completedIndex.clamp(0, points.length - 1);

    // Completed section
    if (clampedIndex > 0) {
      polylines.add(Polyline(
        points: points.sublist(0, clampedIndex + 1),
        strokeWidth: strokeWidth,
        color: theme.success,
      ));
    }

    // Remaining section
    if (clampedIndex < points.length - 1) {
      polylines.add(Polyline(
        points: points.sublist(clampedIndex),
        strokeWidth: strokeWidth,
        color: theme.activeColor,
      ));
    }

    return polylines;
  }

  /// Traffic-aware route with color coding
  static List<Polyline> trafficRoute(
    List<LatLng> points,
    List<TrafficLevel> trafficLevels,
    BuildContext context, {
    double strokeWidth = defaultStrokeWidth,
  }) {
    if (points.length < 2 || trafficLevels.isEmpty) return [];

    final theme = appColor(context).appTheme;
    final List<Polyline> polylines = [];
    final segmentCount = points.length - 1;

    for (int i = 0; i < segmentCount && i < trafficLevels.length; i++) {
      polylines.add(Polyline(
        points: [points[i], points[i + 1]],
        strokeWidth: strokeWidth,
        color: trafficLevels[i].getColor(theme),
      ));
    }

    return polylines;
  }
}

/// Circle markers for zones and geofencing
class MapCircles {
  /// Safe zone circle (uses theme success color)
  static CircleMarker safeZone(
    LatLng center,
    BuildContext context, {
    required double radiusMeters,
    double borderWidth = 2.0,
  }) {
    final theme = appColor(context).appTheme;
    return CircleMarker(
      point: center,
      radius: radiusMeters,
      useRadiusInMeter: true,
      color: theme.success.withValues(alpha: 0.2),
      borderColor: theme.success,
      borderStrokeWidth: borderWidth,
    );
  }

  /// Alert zone circle (uses theme alert zone color)
  static CircleMarker alertZone(
    LatLng center,
    BuildContext context, {
    required double radiusMeters,
    double borderWidth = 2.0,
  }) {
    final theme = appColor(context).appTheme;
    return CircleMarker(
      point: center,
      radius: radiusMeters,
      useRadiusInMeter: true,
      color: theme.alertZone.withValues(alpha: 0.2),
      borderColor: theme.alertZone,
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

  /// GPS accuracy indicator circle (uses theme primary color)
  static CircleMarker accuracyCircle(
    LatLng center,
    BuildContext context, {
    required double accuracyMeters,
  }) {
    final theme = appColor(context).appTheme;
    return CircleMarker(
      point: center,
      radius: accuracyMeters,
      useRadiusInMeter: true,
      color: theme.primary.withValues(alpha: 0.15),
      borderColor: theme.primary.withValues(alpha: 0.3),
      borderStrokeWidth: 1.0,
    );
  }
}

/// Traffic level enum for traffic-aware routing
enum TrafficLevel {
  free,
  light,
  moderate,
  heavy,
  severe;

  /// Get color based on app theme
  Color getColor(AppTheme theme) {
    switch (this) {
      case TrafficLevel.free:
        return theme.success;
      case TrafficLevel.light:
        return Colors.lightGreen;
      case TrafficLevel.moderate:
        return theme.yellowIcon;
      case TrafficLevel.heavy:
        return Colors.orange;
      case TrafficLevel.severe:
        return theme.alertZone;
    }
  }
}
