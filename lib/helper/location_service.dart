import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Service to handle user location operations
class LocationService {
  /// Cache last known location
  static LatLng? _lastKnownLocation;

  /// Get current user location
  /// Returns LatLng if successful, null if permission denied or error
  static Future<LatLng?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _lastKnownLocation;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _lastKnownLocation;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _lastKnownLocation;
      }

      // Get current position with timeout
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () async {
          final pos = await Geolocator.getLastKnownPosition();
          if (pos != null) return pos;
          throw Exception('No location available');
        },
      );

      _lastKnownLocation = LatLng(position.latitude, position.longitude);
      return _lastKnownLocation;
    } catch (e) {
      return _lastKnownLocation;
    }
  }

  /// Get continuous location stream for real-time tracking
  static Stream<Position> getLocationStream({
    int distanceFilter = 15,
    Duration? timeLimit,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilter,
        timeLimit: timeLimit,
      ),
    );
  }

  /// Request location permission
  static Future<bool> requestPermission({bool allowAlways = false}) async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (allowAlways && permission == LocationPermission.whileInUse) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Check if location permission is granted
  static Future<bool> hasPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Open app settings
  static Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }

  /// Open location settings
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Get last known location (cached)
  static LatLng? get lastKnownLocation => _lastKnownLocation;
}
