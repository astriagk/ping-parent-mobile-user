import '../../config.dart';

/// Generic map markers for all map providers
/// Uses app theme colors and consistent styling
class MapMarkers {
  /// Default marker size
  static double defaultSize = Sizes.s40;

  /// Pickup location marker (green pin with optional label)
  static Marker pickupMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
    double? size,
    String? label,
  }) {
    size ??= Sizes.s40;
    final theme = appColor(context).appTheme;
    return Marker(
      point: point,
      width: size,
      height: size + (label != null ? 20 : 0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.success,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: AppCss.lexendMedium10.textColor(Colors.white),
                ),
              ),
            Icon(
              Icons.location_on,
              color: theme.success,
              size: size,
            ),
          ],
        ),
      ),
    );
  }

  /// Drop/Destination location marker (red pin with optional label)
  static Marker dropMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
    double? size,
    String? label,
  }) {
    size ??= Sizes.s40;
    final theme = appColor(context).appTheme;
    return Marker(
      point: point,
      width: size,
      height: size + (label != null ? 20 : 0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.alertZone,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: AppCss.lexendMedium10.textColor(Colors.white),
                ),
              ),
            Icon(
              Icons.flag,
              color: theme.alertZone,
              size: size,
            ),
          ],
        ),
      ),
    );
  }

  /// Current user location marker (blue dot with pulse effect)
  static Marker currentLocationMarker(
    LatLng point,
    BuildContext context, {
    double? size,
  }) {
    size ??= Sizes.s40;
    return Marker(
      point: point,
      width: size,
      height: size,
      child: SvgPicture.asset(
        svgAssets.locationPin,
        width: size,
        height: size,
      ),
    );
  }

  /// Driver/Vehicle location marker with optional heading
  static Marker driverMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
    double? size,
    double? heading,
  }) {
    size ??= Sizes.s40;
    final theme = appColor(context).appTheme;
    return Marker(
      point: point,
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: Transform.rotate(
          angle: heading != null ? heading * (3.14159 / 180) : 0,
          child: Container(
            decoration: BoxDecoration(
              color: theme.bgBox,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.directions_car,
              color: theme.darkText,
              size: size * 0.7,
            ),
          ),
        ),
      ),
    );
  }

  /// School/Building marker
  static Marker schoolMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
    double? size,
    String? label,
  }) {
    size ??= Sizes.s40;
    final theme = appColor(context).appTheme;
    return Marker(
      point: point,
      width: size + 20,
      height: size + (label != null ? 24 : 0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: size * 0.5,
              ),
            ),
            if (label != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: AppCss.lexendMedium10.textColor(Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Home marker
  static Marker homeMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
    double? size,
  }) {
    size ??= Sizes.s40;
    return Marker(
      point: point,
      width: size,
      height: size,
      child: SvgPicture.asset(
        svgAssets.homeDark,
        width: size,
        height: size,
      ),
    );
  }

  /// Numbered marker (for multi-stop routes)
  static Marker numberedMarker(
    LatLng point,
    BuildContext context, {
    required int number,
    VoidCallback? onTap,
    double? size,
    Color? color,
  }) {
    size ??= 32.0;
    final theme = appColor(context).appTheme;
    final markerColor = color ?? theme.primary;
    return Marker(
      point: point,
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: markerColor.withValues(alpha: 0.4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$number',
              style: AppCss.lexendMedium14.textColor(Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  /// Custom marker with icon
  static Marker customMarker({
    required LatLng point,
    required BuildContext context,
    required IconData icon,
    Color? color,
    Color iconColor = Colors.white,
    double? size,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    size ??= Sizes.s40;
    final theme = appColor(context).appTheme;
    final markerColor = color ?? theme.primary;
    return Marker(
      point: point,
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: Tooltip(
          message: tooltip ?? '',
          child: Container(
            decoration: BoxDecoration(
              color: markerColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: markerColor.withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: size * 0.6,
            ),
          ),
        ),
      ),
    );
  }

  /// SVG marker from asset
  static Marker svgMarker({
    required LatLng point,
    required String assetPath,
    double? size,
    VoidCallback? onTap,
  }) {
    size ??= Sizes.s40;
    return Marker(
      point: point,
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
        ),
      ),
    );
  }

  /// Image marker from network URL
  static Marker imageMarker({
    required LatLng point,
    required String imageUrl,
    double? size,
    VoidCallback? onTap,
    BoxFit fit = BoxFit.cover,
  }) {
    size ??= Sizes.s40;
    return Marker(
      point: point,
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: Image.network(
            imageUrl,
            width: size,
            height: size,
            fit: fit,
            errorBuilder: (_, __, ___) => Icon(
              Icons.person,
              size: size,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
