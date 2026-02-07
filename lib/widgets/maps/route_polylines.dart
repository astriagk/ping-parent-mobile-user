import 'package:taxify_user_ui/config.dart';

/// Reusable polyline builder for all map providers
class RoutePolylines {
  static Polyline activeRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appColor(context).appTheme.primary,
      strokeWidth: Insets.i2,
      borderColor: appColor(context).appTheme.primary.withOpacity(0.8),
      borderStrokeWidth: Insets.i1,
    );
  }

  static Polyline customRoute({
    required List<LatLng> points,
    required Color color,
    double strokeWidth = 2.0,
    bool isDotted = false,
  }) {
    return Polyline(
      points: points,
      color: color,
      strokeWidth: strokeWidth,
      pattern:
          isDotted ? const StrokePattern.dotted() : const StrokePattern.solid(),
    );
  }
}
