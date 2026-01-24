import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../common/tomtom_config.dart';

/// TomTom Advanced Routing Screen
/// Demonstrates TomTom's premium routing features
/// Including traffic-aware routing, alternative routes, and ETA
class TTAdvancedRoutingScreen extends StatefulWidget {
  const TTAdvancedRoutingScreen({super.key});

  @override
  State<TTAdvancedRoutingScreen> createState() =>
      _TTAdvancedRoutingScreenState();
}

class _TTAdvancedRoutingScreenState extends State<TTAdvancedRoutingScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 11.0;
  LatLng _center = const LatLng(37.7749, -122.4194);

  // Route points
  LatLng? _origin;
  LatLng? _destination;
  bool _isSelectingOrigin = true;

  // Route data
  List<RouteOption> _routes = [];
  int _selectedRouteIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Routing options
  String _travelMode = 'car';
  bool _avoidTolls = false;
  bool _avoidHighways = false;
  String _routeType = 'fastest';

  final List<Map<String, dynamic>> _travelModes = [
    {'id': 'car', 'name': 'Car', 'icon': Icons.directions_car},
    {'id': 'truck', 'name': 'Truck', 'icon': Icons.local_shipping},
    {'id': 'motorcycle', 'name': 'Motorcycle', 'icon': Icons.two_wheeler},
    {'id': 'bicycle', 'name': 'Bicycle', 'icon': Icons.pedal_bike},
    {'id': 'pedestrian', 'name': 'Walk', 'icon': Icons.directions_walk},
  ];

  final List<Map<String, String>> _routeTypes = [
    {'id': 'fastest', 'name': 'Fastest'},
    {'id': 'shortest', 'name': 'Shortest'},
    {'id': 'eco', 'name': 'Eco-friendly'},
    {'id': 'thrilling', 'name': 'Scenic'},
  ];

  Future<void> _calculateRoute() async {
    if (_origin == null || _destination == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _routes = [];
    });

    try {
      final avoid = <String>[];
      if (_avoidTolls) avoid.add('tollRoads');
      if (_avoidHighways) avoid.add('motorways');

      final avoidParam = avoid.isNotEmpty ? '&avoid=${avoid.join(',')}' : '';
      final url =
          '${TomTomConfig.routingBaseUrl}/calculateRoute/${_origin!.latitude},${_origin!.longitude}:${_destination!.latitude},${_destination!.longitude}/json'
          '?key=${TomTomConfig.apiKey}'
          '&travelMode=$_travelMode'
          '&routeType=$_routeType'
          '&traffic=true'
          '&maxAlternatives=2'
          '&computeTravelTimeFor=all'
          '&sectionType=traffic'
          '$avoidParam';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final routesList = <RouteOption>[];

        if (data['routes'] != null) {
          int index = 0;
          for (final route in data['routes']) {
            routesList.add(RouteOption.fromJson(route, index++));
          }
        }

        setState(() {
          _routes = routesList;
          _isLoading = false;
          _selectedRouteIndex = 0;
        });

        // Fit map to route
        if (_routes.isNotEmpty) {
          _fitMapToRoute(_routes[0]);
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to calculate route: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _fitMapToRoute(RouteOption route) {
    if (route.points.isEmpty) return;

    double minLat = route.points.first.latitude;
    double maxLat = route.points.first.latitude;
    double minLng = route.points.first.longitude;
    double maxLng = route.points.first.longitude;

    for (final point in route.points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(
          LatLng(minLat, minLng),
          LatLng(maxLat, maxLng),
        ),
        padding: const EdgeInsets.all(50),
      ),
    );
  }

  List<Polyline> _buildRoutePolylines() {
    final polylines = <Polyline>[];

    // Draw non-selected routes first (grey)
    for (int i = 0; i < _routes.length; i++) {
      if (i != _selectedRouteIndex) {
        polylines.add(Polyline(
          points: _routes[i].points,
          strokeWidth: 5,
          color: Colors.grey.shade400,
        ));
      }
    }

    // Draw selected route on top
    if (_selectedRouteIndex < _routes.length) {
      final route = _routes[_selectedRouteIndex];
      polylines.add(Polyline(
        points: route.points,
        strokeWidth: 6,
        color: Colors.blue,
      ));
    }

    return polylines;
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    if (_origin != null) {
      markers.add(Marker(
        point: _origin!,
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Icon(Icons.trip_origin, color: Colors.white, size: 20),
        ),
      ));
    }

    if (_destination != null) {
      markers.add(Marker(
        point: _destination!,
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 20),
        ),
      ));
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Routing'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showRoutingOptions,
          ),
          if (_origin != null || _destination != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearRoute,
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: _currentZoom,
              minZoom: 5.0,
              maxZoom: 18.0,
              onTap: (tapPosition, point) => _handleMapTap(point),
              onPositionChanged: (position, hasGesture) {
                _currentZoom = position.zoom;
                _center = position.center;
              },
            ),
            children: [
              // Base map with traffic
              TileLayer(
                urlTemplate: TomTomConfig.allTileOptions[0]['url']!,
                userAgentPackageName: TomTomConfig.userAgentPackageName,
              ),
              // Traffic flow layer
              TileLayer(
                urlTemplate:
                    'https://api.tomtom.com/traffic/map/4/tile/flow/relative/{z}/{x}/{y}.png?key=${TomTomConfig.apiKey}&thickness=2',
                userAgentPackageName: TomTomConfig.userAgentPackageName,
              ),
              // Route polylines
              PolylineLayer(polylines: _buildRoutePolylines()),
              // Markers
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),
          // Instructions card
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildInstructionsCard(),
          ),
          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
          // Route options
          if (_routes.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildRouteOptionsCard(),
            ),
          // Travel mode selector
          Positioned(
            left: 16,
            bottom: _routes.isNotEmpty ? 180 : 100,
            child: _buildTravelModeSelector(),
          ),
          // Zoom controls
          Positioned(
            right: 16,
            bottom: _routes.isNotEmpty ? 180 : 100,
            child: Column(
              children: [
                _buildControlButton(
                  icon: Icons.add,
                  onPressed: () {
                    final newZoom = (_currentZoom + 1).clamp(5.0, 18.0);
                    _mapController.move(_center, newZoom);
                  },
                ),
                const SizedBox(height: 8),
                _buildControlButton(
                  icon: Icons.remove,
                  onPressed: () {
                    final newZoom = (_currentZoom - 1).clamp(5.0, 18.0);
                    _mapController.move(_center, newZoom);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.grey.shade800, size: 24),
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    final String instruction;
    final Color color;
    final IconData icon;

    if (_origin == null) {
      instruction = 'Tap to set starting point';
      color = Colors.green;
      icon = Icons.trip_origin;
    } else if (_destination == null) {
      instruction = 'Tap to set destination';
      color = Colors.red;
      icon = Icons.location_on;
    } else if (_routes.isEmpty && !_isLoading) {
      instruction = 'Calculating route...';
      color = Colors.blue;
      icon = Icons.route;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            instruction,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelModeSelector() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _travelModes.map((mode) {
          final isSelected = mode['id'] == _travelMode;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () {
                setState(() => _travelMode = mode['id']);
                if (_origin != null && _destination != null) {
                  _calculateRoute();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  mode['icon'],
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  size: 24,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRouteOptionsCard() {
    return Material(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.route, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    '${_routes.length} Route${_routes.length > 1 ? 's' : ''} Found',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _routes.length,
                  itemBuilder: (context, index) {
                    final route = _routes[index];
                    final isSelected = index == _selectedRouteIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedRouteIndex = index);
                        _fitMapToRoute(route);
                      },
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.shade50
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color:
                                      isSelected ? Colors.blue : Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  route.formattedDuration,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isSelected ? Colors.blue : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              route.formattedDistance,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (route.trafficDelay > 0)
                              Text(
                                '+${(route.trafficDelay / 60).round()} min traffic',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMapTap(LatLng point) {
    setState(() {
      if (_isSelectingOrigin) {
        _origin = point;
        _isSelectingOrigin = false;
        _routes = [];
      } else {
        _destination = point;
        _isSelectingOrigin = true;
        _calculateRoute();
      }
    });
  }

  void _clearRoute() {
    setState(() {
      _origin = null;
      _destination = null;
      _routes = [];
      _isSelectingOrigin = true;
    });
  }

  void _showRoutingOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Route Type',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _routeTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type['name']!),
                    selected: _routeType == type['id'],
                    onSelected: (selected) {
                      if (selected) {
                        setModalState(() => _routeType = type['id']!);
                        setState(() {});
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Avoid',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SwitchListTile(
                title: const Text('Toll roads'),
                value: _avoidTolls,
                onChanged: (value) {
                  setModalState(() => _avoidTolls = value);
                  setState(() {});
                },
              ),
              SwitchListTile(
                title: const Text('Highways'),
                value: _avoidHighways,
                onChanged: (value) {
                  setModalState(() => _avoidHighways = value);
                  setState(() {});
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (_origin != null && _destination != null) {
                      _calculateRoute();
                    }
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Route option data model
class RouteOption {
  final int index;
  final List<LatLng> points;
  final int distanceMeters;
  final int travelTimeSeconds;
  final int trafficDelay;

  RouteOption({
    required this.index,
    required this.points,
    required this.distanceMeters,
    required this.travelTimeSeconds,
    this.trafficDelay = 0,
  });

  factory RouteOption.fromJson(Map<String, dynamic> json, int index) {
    final summary = json['summary'] ?? {};
    final legs = json['legs'] as List? ?? [];
    final points = <LatLng>[];

    for (final leg in legs) {
      final legPoints = leg['points'] as List? ?? [];
      for (final point in legPoints) {
        points.add(LatLng(
          point['latitude'].toDouble(),
          point['longitude'].toDouble(),
        ));
      }
    }

    return RouteOption(
      index: index,
      points: points,
      distanceMeters: summary['lengthInMeters'] ?? 0,
      travelTimeSeconds: summary['travelTimeInSeconds'] ?? 0,
      trafficDelay: summary['trafficDelayInSeconds'] ?? 0,
    );
  }

  String get formattedDistance {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '$distanceMeters m';
  }

  String get formattedDuration {
    final hours = travelTimeSeconds ~/ 3600;
    final minutes = (travelTimeSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '$minutes min';
  }
}
