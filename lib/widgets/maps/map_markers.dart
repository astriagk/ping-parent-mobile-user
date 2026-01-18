import '../../config.dart';

/// Custom marker builders for different location types
class MapMarkers {
  /// Pickup location marker (green/success)
  static Marker pickupMarker({
    required LatLng point,
    required int number,
    required BuildContext context,
    VoidCallback? onTap,
  }) {
    final theme = appColor(context).appTheme;
    return Marker(
      point: point,
      width: 80,
      height: 80,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: theme.darkText.withValues(alpha:0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                '$number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: theme.darkText,
                ),
              ),
            ),
            Icon(
              Icons.location_pin,
              color: theme.success,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }

  /// Drop location marker (red/alertZone)
  static Marker dropMarker({
    required LatLng point,
    required BuildContext context,
    VoidCallback? onTap,
  }) {
    final theme = appColor(context).appTheme;
    return Marker(
      point: point,
      width: 80,
      height: 80,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(
              Icons.flag,
              color: theme.alertZone,
              size: 30,
            ),
            Icon(
              Icons.location_pin,
              color: theme.alertZone,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }

  /// Current location marker (blue/activeColor)
  static Marker currentLocationMarker({
    required LatLng point,
    required BuildContext context,
    bool isMoving = false,
  }) {
    final theme = appColor(context).appTheme;
    return Marker(
      point: point,
      width: 60,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: theme.activeColor,
          shape: BoxShape.circle,
          border: Border.all(color: theme.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: theme.darkText.withValues(alpha:0.3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Icon(
          isMoving ? Icons.navigation : Icons.location_on,
          color: theme.white,
          size: 30,
        ),
      ),
    );
  }

  /// Driver location marker with custom icon
  static Marker driverMarker({
    required LatLng point,
    required BuildContext context,
    String? driverName,
    VoidCallback? onTap,
  }) {
    final theme = appColor(context).appTheme;
    return Marker(
      point: point,
      width: 80,
      height: 100,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            if (driverName != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.darkText.withValues(alpha:0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  driverName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: theme.darkText,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.activeColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car,
                color: theme.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Generic marker with custom color and icon
  static Marker customMarker({
    required LatLng point,
    required IconData icon,
    required Color color,
    required BuildContext context,
    String? label,
    VoidCallback? onTap,
  }) {
    final theme = appColor(context).appTheme;
    return Marker(
      point: point,
      width: 80,
      height: 80,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            if (label != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: theme.darkText.withValues(alpha:0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: theme.darkText,
                  ),
                ),
              ),
            Icon(
              icon,
              color: color,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
