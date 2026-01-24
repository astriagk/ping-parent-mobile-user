import 'dart:async';
import 'package:taxify_user_ui/widgets/maps/layout/osm_tile_layer.dart';
import 'package:taxify_user_ui/widgets/map_common/markers.dart';

import '../../config.dart';

/// Real-time location tracking example
/// Simulates driver tracking with live position updates
class RealtimeTrackingScreen extends StatefulWidget {
  const RealtimeTrackingScreen({super.key});

  @override
  State<RealtimeTrackingScreen> createState() => _RealtimeTrackingScreenState();
}

class _RealtimeTrackingScreenState extends State<RealtimeTrackingScreen> {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;

  LatLng? _currentLocation;
  List<LatLng> _routePath = [];
  bool _isTracking = false;
  double _totalDistance = 0.0;
  String _currentSpeed = '0 km/h';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _routePath.add(_currentLocation!);
      });
    } catch (e) {
      // Handle error
    }
  }

  void _startTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      final newLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        if (_currentLocation != null) {
          // Calculate distance from last point
          final distance = Geolocator.distanceBetween(
            _currentLocation!.latitude,
            _currentLocation!.longitude,
            newLocation.latitude,
            newLocation.longitude,
          );
          _totalDistance += distance;
        }

        _currentLocation = newLocation;
        _routePath.add(newLocation);

        // Calculate speed (m/s to km/h)
        _currentSpeed = '${(position.speed * 3.6).toStringAsFixed(1)} km/h';
      });

      // Auto-center map on current location
      _mapController.move(_currentLocation!, 16.0);
    });

    setState(() => _isTracking = true);
  }

  void _stopTracking() {
    _positionStreamSubscription?.cancel();
    setState(() => _isTracking = false);
  }

  void _clearRoute() {
    setState(() {
      _routePath.clear();
      _totalDistance = 0.0;
      if (_currentLocation != null) {
        _routePath.add(_currentLocation!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;
    return Scaffold(
      backgroundColor: theme.screenBg,
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: Text('Real-time Tracking', style: TextStyle(color: theme.white)),
        iconTheme: IconThemeData(color: theme.white),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: theme.white),
            onPressed: _clearRoute,
            tooltip: 'Clear route',
          ),
        ],
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation!,
                    initialZoom: 16.0,
                  ),
                  children: [
                    OSMTileLayer(),
                    // Route path
                    if (_routePath.length > 1)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routePath,
                            color: theme.activeColor,
                            strokeWidth: 4.0,
                          ),
                        ],
                      ),
                    // Current location marker
                    if (_currentLocation != null)
                      MarkerLayer(
                        markers: [
                          MapMarkers.currentLocationMarker(
                              _currentLocation!, context),
                        ],
                      ),
                  ],
                ),
                // Stats overlay
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: theme.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                context,
                                'Distance',
                                '${(_totalDistance / 1000).toStringAsFixed(2)} km',
                                Icons.straighten,
                              ),
                              _buildStatItem(
                                context,
                                'Speed',
                                _currentSpeed,
                                Icons.speed,
                              ),
                              _buildStatItem(
                                context,
                                'Points',
                                '${_routePath.length}',
                                Icons.location_on,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Control buttons
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              _isTracking ? _stopTracking : _startTracking,
                          icon: Icon(
                            _isTracking ? Icons.stop : Icons.play_arrow,
                            color: theme.white,
                          ),
                          label: Text(
                            _isTracking ? 'Stop' : 'Start Tracking',
                            style: TextStyle(color: theme.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isTracking ? theme.alertZone : theme.success,
                            foregroundColor: theme.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentLocation != null) {
                            _mapController.move(_currentLocation!, 16.0);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          padding: const EdgeInsets.all(16),
                        ),
                        child: Icon(Icons.my_location, color: theme.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, IconData icon) {
    final theme = appColor(context).appTheme;
    return Column(
      children: [
        Icon(icon, size: 24, color: theme.activeColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.darkText,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.lightText,
          ),
        ),
      ],
    );
  }
}
