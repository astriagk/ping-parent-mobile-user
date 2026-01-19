import '../../config.dart';

/// Custom marker builders for different location types
class MapMarkers {
  /// Pickup location marker (green)
  static Marker pickupMarker(LatLng point, BuildContext context,
      {VoidCallback? onTap}) {
    return Marker(
      point: point,
      width: Sizes.s40,
      height: Sizes.s40,
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(svgAssets.locationPin,
            width: Sizes.s40, height: Sizes.s40),
      ),
    );
  }

  /// Drop location marker (red)
  static Marker dropMarker(LatLng point, BuildContext context,
      {VoidCallback? onTap}) {
    return Marker(
      point: point,
      width: Sizes.s40,
      height: Sizes.s40,
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(svgAssets.routing,
            width: Sizes.s40, height: Sizes.s40),
      ),
    );
  }

  /// Current location marker
  static Marker currentLocationMarker(LatLng point, BuildContext context) {
    return Marker(
      point: point,
      width: Sizes.s40,
      height: Sizes.s40,
      child: SvgPicture.asset(svgAssets.locationPin,
          width: Sizes.s40, height: Sizes.s40),
    );
  }

  /// Driver location marker
  static Marker driverMarker(LatLng point, BuildContext context,
      {VoidCallback? onTap}) {
    return Marker(
      point: point,
      width: Sizes.s40,
      height: Sizes.s40,
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(svgAssets.car,
            width: Sizes.s40, height: Sizes.s40),
      ),
    );
  }

  /// Custom marker with specified icon and color
  static Marker customMarker({
    required LatLng point,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      width: Sizes.s40,
      height: Sizes.s40,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: color, size: Sizes.s40),
      ),
    );
  }
}
