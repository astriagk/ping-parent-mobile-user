import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../widgets/open_free_maps/index.dart';

/// Real-time location tracking example
/// Demonstrates live GPS tracking with route path recording
/// Shows speed, distance, and other tracking statistics
class OFMRealtimeTrackingScreen extends StatefulWidget {
  const OFMRealtimeTrackingScreen({super.key});

  @override
  State<OFMRealtimeTrackingScreen> createState() =>
      _OFMRealtimeTrackingScreenState();
}

class _OFMRealtimeTrackingScreenState extends State<OFMRealtimeTrackingScreen> {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;

  LatLng? _currentLocation;
  List<LatLng> _routePath = [];
  bool _isTracking = false;
  bool _isLoading = true;
  double _totalDistance = 0.0;
  double _currentSpeed = 0.0;
  DateTime? _startTime;
  bool _autoCenter = true;
  bool _mapReady = false;

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
      if (!serviceEnabled) {
        setState(() => _isLoading = false);
        _showError('Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoading = false);
          _showError('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoading = false);
        _showError('Location permission permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _routePath.add(_currentLocation!);
        _isLoading = false;
      });

      // Only move if map is already rendered
      if (_mapReady) {
        _mapController.move(_currentLocation!, 16.0);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error getting location');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _startTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Update every 5 meters
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
        _currentSpeed = position.speed; // m/s
      });

      // Auto-center map on current location
      if (_autoCenter && _mapReady) {
        _mapController.move(_currentLocation!, _mapController.camera.zoom);
      }
    });

    setState(() {
      _isTracking = true;
      _startTime = DateTime.now();
    });
  }

  void _stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    setState(() => _isTracking = false);
  }

  void _clearRoute() {
    setState(() {
      _routePath.clear();
      _totalDistance = 0.0;
      _startTime = null;
      if (_currentLocation != null) {
        _routePath.add(_currentLocation!);
      }
    });
  }

  String _formatDuration() {
    if (_startTime == null) return '00:00';
    final duration = DateTime.now().difference(_startTime!);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Tracking'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_autoCenter ? Icons.gps_fixed : Icons.gps_not_fixed),
            onPressed: () => setState(() => _autoCenter = !_autoCenter),
            tooltip: _autoCenter ? 'Auto-center ON' : 'Auto-center OFF',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearRoute,
            tooltip: 'Clear route',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentLocation == null
              ? _buildErrorState()
              : Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _currentLocation!,
                        initialZoom: 16.0,
                        onMapReady: () {
                          _mapReady = true;
                        },
                        onPositionChanged: (camera, hasGesture) {
                          if (hasGesture && _autoCenter) {
                            setState(() => _autoCenter = false);
                          }
                        },
                      ),
                      children: [
                        const OFMTileLayer(),
                        // Route path
                        if (_routePath.length > 1)
                          PolylineLayer(
                            polylines: [
                              MapPolylines.activeRoute(
                                _routePath,
                                context,
                              ),
                            ],
                          ),
                        // Current location marker
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
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                Icons.straighten,
                                MapUtils.formatDistance(_totalDistance),
                                'Distance',
                              ),
                              _buildStatItem(
                                Icons.speed,
                                MapUtils.formatSpeed(_currentSpeed),
                                'Speed',
                              ),
                              _buildStatItem(
                                Icons.timer,
                                _formatDuration(),
                                'Duration',
                              ),
                              _buildStatItem(
                                Icons.location_on,
                                '${_routePath.length}',
                                'Points',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Tracking status indicator
                    if (_isTracking)
                      Positioned(
                        top: 100,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Tracking active',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                      child: SafeArea(
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isTracking
                                    ? _stopTracking
                                    : _startTracking,
                                icon: Icon(
                                  _isTracking ? Icons.stop : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  _isTracking ? 'Stop' : 'Start Tracking',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _isTracking ? Colors.red : Colors.green,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                if (_currentLocation != null) {
                                  _mapController.move(_currentLocation!, 16.0);
                                  setState(() => _autoCenter = true);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Icon(Icons.my_location,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('Unable to get location'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() => _isLoading = true);
              _getCurrentLocation();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
