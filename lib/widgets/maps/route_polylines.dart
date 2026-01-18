import '../../config.dart';

/// Route polyline styles for different use cases
class RoutePolylines {
  /// Active route (solid blue line)
  static Polyline activeRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appColor(context).appTheme.activeColor,
      strokeWidth: 4.0,
    );
  }

  /// Planned route (dotted line)
  static Polyline plannedRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appColor(context).appTheme.dashColor,
      strokeWidth: 3.0,
    );
  }

  /// Completed route (green)
  static Polyline completedRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appColor(context).appTheme.success,
      strokeWidth: 3.0,
    );
  }

  /// Alternative route (dashed orange)
  static Polyline alternativeRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appColor(context).appTheme.yellowIcon,
      strokeWidth: 3.0,
    );
  }

  /// Alert/danger route (red)
  static Polyline alertRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appColor(context).appTheme.alertZone,
      strokeWidth: 4.0,
    );
  }

  /// Custom route with specified color and width
  static Polyline customRoute({
    required List<LatLng> points,
    required Color color,
    double strokeWidth = 3.0,
  }) {
    return Polyline(
      points: points,
      color: color,
      strokeWidth: strokeWidth,
    );
  }

  /// Multi-segment route with gradient colors
  static List<Polyline> gradientRoute(
    List<LatLng> points,
    BuildContext context, {
    Color? startColor,
    Color? endColor,
    int segments = 5,
  }) {
    if (points.length < 2) return [];

    final theme = appColor(context).appTheme;
    List<Polyline> polylines = [];
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
          strokeWidth: 4.0,
        ),
      );
    }

    return polylines;
  }
}
