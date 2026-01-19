import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

/// Custom marker builders for different location types
/// Provides pre-styled markers for common use cases
class OFMMarkers {
  /// Default marker size
  static const double defaultSize = 40.0;

  /// Pickup location marker (green pin)
  static Marker pickupMarker(
    LatLng point, {
    VoidCallback? onTap,
    double size = defaultSize,
    String? label,
  }) {
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
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Icon(
              Icons.location_on,
              color: Colors.green.shade700,
              size: size,
            ),
          ],
        ),
      ),
    );
  }

  /// Drop/Destination location marker (red pin)
  static Marker dropMarker(
    LatLng point, {
    VoidCallback? onTap,
    double size = defaultSize,
    String? label,
  }) {
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
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Icon(
              Icons.flag,
              color: Colors.red.shade700,
              size: size,
            ),
          ],
        ),
      ),
    );
  }

  /// Current user location marker (blue dot with pulse effect)
  static Marker currentLocationMarker(
    LatLng point, {
    double size = 24.0,
    Color color = Colors.blue,
  }) {
    return Marker(
      point: point,
      width: size * 2,
      height: size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulse ring
          Container(
            width: size * 2,
            height: size * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.2),
            ),
          ),
          // Inner dot
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Driver/Vehicle location marker
  static Marker driverMarker(
    LatLng point, {
    VoidCallback? onTap,
    double size = defaultSize,
    double? heading,
    Color color = Colors.black,
  }) {
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
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.directions_car,
              color: color,
              size: size * 0.7,
            ),
          ),
        ),
      ),
    );
  }

  /// School/Building marker
  static Marker schoolMarker(
    LatLng point, {
    VoidCallback? onTap,
    double size = defaultSize,
    String? label,
  }) {
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
                color: Colors.blue.shade700,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.3),
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
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
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
    LatLng point, {
    VoidCallback? onTap,
    double size = defaultSize,
  }) {
    return Marker(
      point: point,
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange.shade700,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.home,
            color: Colors.white,
            size: size * 0.6,
          ),
        ),
      ),
    );
  }

  /// Numbered marker (for multi-stop routes)
  static Marker numberedMarker(
    LatLng point, {
    required int number,
    VoidCallback? onTap,
    double size = 32.0,
    Color? color,
  }) {
    final markerColor = color ?? Colors.blue.shade700;
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
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Custom marker with icon
  static Marker customMarker({
    required LatLng point,
    required IconData icon,
    Color color = Colors.blue,
    Color iconColor = Colors.white,
    double size = defaultSize,
    VoidCallback? onTap,
    String? tooltip,
  }) {
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
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
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
    double size = defaultSize,
    VoidCallback? onTap,
  }) {
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
    double size = defaultSize,
    VoidCallback? onTap,
    BoxFit fit = BoxFit.cover,
  }) {
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
