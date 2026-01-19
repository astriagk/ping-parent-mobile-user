import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../widgets/open_free_maps/index.dart';

/// Route planning screen with OSRM routing
/// Demonstrates route calculation between multiple waypoints
/// Uses free OSRM service for routing (no API key required)
class OFMRoutePlanningScreen extends StatefulWidget {
  const OFMRoutePlanningScreen({super.key});

  @override
  State<OFMRoutePlanningScreen> createState() => _OFMRoutePlanningScreenState();
}

class _OFMRoutePlanningScreenState extends State<OFMRoutePlanningScreen> {
  final MapController _mapController = MapController();

  List<LatLng> _waypoints = [];
  List<LatLng> _routePoints = [];
  OFMRouteResult? _routeInfo;
  bool _isLoading = false;
  bool _isInitialLoading = true;
  LatLng? _currentLocation;
  OFMRouteProfile _selectedProfile = OFMRouteProfile.driving;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _isInitialLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isInitialLoading = false;
      });

      // Only move if map is already rendered
      if (_mapReady) {
        _mapController.move(_currentLocation!, 14.0);
      }
    } catch (e) {
      setState(() => _isInitialLoading = false);
    }
  }

  Future<void> _calculateRoute() async {
    if (_waypoints.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 2 waypoints')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final route = await OFMRoutingService.getRoute(
        _waypoints,
        profile: _selectedProfile,
      );

      if (route != null) {
        setState(() {
          _routePoints = route.points;
          _routeInfo = route;
        });
        if (_mapReady) {
          OFMUtils.fitBounds(_mapController, _waypoints);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not calculate route')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _optimizeRoute() async {
    if (_waypoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need at least 3 waypoints to optimize')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final trip = await OFMRoutingService.getOptimizedTrip(
        _waypoints,
        profile: _selectedProfile,
      );

      if (trip != null) {
        // Reorder waypoints according to optimized order
        final optimizedWaypoints =
            trip.optimizedOrder.map((index) => _waypoints[index]).toList();

        setState(() {
          _waypoints = optimizedWaypoints;
          _routePoints = trip.points;
          _routeInfo = trip;
        });

        if (_mapReady) {
          OFMUtils.fitBounds(_mapController, _waypoints);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Route optimized!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error optimizing: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addWaypoint(LatLng point) {
    setState(() {
      _waypoints.add(point);
    });

    if (_waypoints.length >= 2) {
      _calculateRoute();
    }
  }

  void _removeWaypoint(int index) {
    setState(() {
      _waypoints.removeAt(index);
      if (_waypoints.length < 2) {
        _routePoints.clear();
        _routeInfo = null;
      }
    });

    if (_waypoints.length >= 2) {
      _calculateRoute();
    }
  }

  void _clearAll() {
    setState(() {
      _waypoints.clear();
      _routePoints.clear();
      _routeInfo = null;
    });
  }

  void _showProfileSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Route Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.directions_car,
                color: _selectedProfile == OFMRouteProfile.driving
                    ? Colors.blue
                    : Colors.grey,
              ),
              title: const Text('Driving'),
              trailing: _selectedProfile == OFMRouteProfile.driving
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => _selectedProfile = OFMRouteProfile.driving);
                Navigator.pop(context);
                if (_waypoints.length >= 2) _calculateRoute();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.directions_walk,
                color: _selectedProfile == OFMRouteProfile.walking
                    ? Colors.blue
                    : Colors.grey,
              ),
              title: const Text('Walking'),
              trailing: _selectedProfile == OFMRouteProfile.walking
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => _selectedProfile = OFMRouteProfile.walking);
                Navigator.pop(context);
                if (_waypoints.length >= 2) _calculateRoute();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.directions_bike,
                color: _selectedProfile == OFMRouteProfile.cycling
                    ? Colors.blue
                    : Colors.grey,
              ),
              title: const Text('Cycling'),
              trailing: _selectedProfile == OFMRouteProfile.cycling
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => _selectedProfile = OFMRouteProfile.cycling);
                Navigator.pop(context);
                if (_waypoints.length >= 2) _calculateRoute();
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getProfileIcon() {
    switch (_selectedProfile) {
      case OFMRouteProfile.driving:
        return Icons.directions_car;
      case OFMRouteProfile.walking:
        return Icons.directions_walk;
      case OFMRouteProfile.cycling:
        return Icons.directions_bike;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Planning'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_getProfileIcon()),
            onPressed: _showProfileSelector,
            tooltip: 'Route profile',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _waypoints.isNotEmpty ? _clearAll : null,
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        _currentLocation ?? const LatLng(37.7749, -122.4194),
                    initialZoom: 14.0,
                    onTap: (_, point) => _addWaypoint(point),
                    onMapReady: () {
                      _mapReady = true;
                    },
                  ),
                  children: [
                    const OFMTileLayer(),
                    // Route polyline
                    if (_routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          OFMPolylines.activeRoute(
                            _routePoints,
                            color: _selectedProfile == OFMRouteProfile.walking
                                ? Colors.orange
                                : _selectedProfile == OFMRouteProfile.cycling
                                    ? Colors.green
                                    : Colors.blue,
                            strokeWidth: 5,
                          ),
                        ],
                      ),
                    // Waypoint markers
                    MarkerLayer(
                      markers: [
                        ..._waypoints.asMap().entries.map((entry) {
                          final index = entry.key;
                          final point = entry.value;
                          final isFirst = index == 0;
                          final isLast = index == _waypoints.length - 1;

                          if (isFirst) {
                            return OFMMarkers.pickupMarker(
                              point,
                              label: 'Start',
                              onTap: () => _showWaypointOptions(index),
                            );
                          } else if (isLast && _waypoints.length > 1) {
                            return OFMMarkers.dropMarker(
                              point,
                              label: 'End',
                              onTap: () => _showWaypointOptions(index),
                            );
                          } else {
                            return OFMMarkers.numberedMarker(
                              point,
                              number: index + 1,
                              color: Colors.blue,
                              onTap: () => _showWaypointOptions(index),
                            );
                          }
                        }),
                      ],
                    ),
                  ],
                ),
                // Route info card
                if (_routeInfo != null)
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(_getProfileIcon(), color: Colors.blue),
                                const SizedBox(width: 8),
                                const Text(
                                  'Route Info',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${_waypoints.length} stops',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildInfoItem(
                                  Icons.straighten,
                                  _routeInfo!.formattedDistance,
                                  'Distance',
                                ),
                                _buildInfoItem(
                                  Icons.access_time,
                                  _routeInfo!.formattedDuration,
                                  'Duration',
                                ),
                              ],
                            ),
                            if (_waypoints.length >= 3) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _isLoading ? null : _optimizeRoute,
                                  icon: const Icon(Icons.auto_fix_high),
                                  label: const Text('Optimize Route'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                // Loading indicator
                if (_isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Calculating route...'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                // Instructions
                if (_waypoints.isEmpty)
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Tap on map to add waypoints',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                // Waypoint list
                if (_waypoints.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 150),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _waypoints.length,
                          itemBuilder: (context, index) {
                            final point = _waypoints[index];
                            final isFirst = index == 0;
                            final isLast = index == _waypoints.length - 1;

                            return ListTile(
                              dense: true,
                              leading: isFirst
                                  ? Icon(Icons.location_on,
                                      color: Colors.green.shade700)
                                  : isLast
                                      ? Icon(Icons.flag,
                                          color: Colors.red.shade700)
                                      : CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.blue,
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                              title: Text(
                                isFirst
                                    ? 'Start'
                                    : isLast
                                        ? 'End'
                                        : 'Stop ${index + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}',
                                style: const TextStyle(fontSize: 11),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => _removeWaypoint(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  void _showWaypointOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.center_focus_strong),
              title: const Text('Center on map'),
              onTap: () {
                Navigator.pop(context);
                _mapController.move(_waypoints[index], 16.0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove waypoint'),
              onTap: () {
                Navigator.pop(context);
                _removeWaypoint(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
