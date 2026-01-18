import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taxify_user_ui/widgets/maps/layout/osm_tile_layer.dart';
import 'package:taxify_user_ui/widgets/maps/map_markers.dart';
import '../../config.dart';

/// Route planning with OSRM (Open Source Routing Machine)
/// Shows optimized routes between multiple points
class RoutePlanningScreen extends StatefulWidget {
  const RoutePlanningScreen({super.key});

  @override
  State<RoutePlanningScreen> createState() => _RoutePlanningScreenState();
}

class _RoutePlanningScreenState extends State<RoutePlanningScreen> {
  final MapController _mapController = MapController();
  List<LatLng> _waypoints = [];
  List<LatLng> _routePoints = [];
  bool _isLoading = false;
  String? _routeInfo;

  // Example locations (San Francisco area)
  final List<LocationPoint> _exampleLocations = [
    LocationPoint(
      name: 'Start Point',
      latLng: const LatLng(37.7749, -122.4194),
    ),
    LocationPoint(
      name: 'Pickup 1',
      latLng: const LatLng(37.7849, -122.4094),
    ),
    LocationPoint(
      name: 'Pickup 2',
      latLng: const LatLng(37.7649, -122.4294),
    ),
    LocationPoint(
      name: 'Destination',
      latLng: const LatLng(37.7949, -122.3994),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _waypoints = _exampleLocations.map((loc) => loc.latLng).toList();
    _calculateRoute();
  }

  Future<void> _calculateRoute() async {
    if (_waypoints.length < 2) return;

    setState(() => _isLoading = true);

    try {
      // Build OSRM API URL with all waypoints
      final coordinates = _waypoints
          .map((point) => '${point.longitude},${point.latitude}')
          .join(';');

      final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$coordinates?'
        'overview=full&geometries=geojson&steps=true',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final route = data['routes'][0];

        // Parse the route geometry
        final geometry = route['geometry']['coordinates'] as List;
        final points =
            geometry.map((coord) => LatLng(coord[1], coord[0])).toList();

        // Get route info
        final distance = route['distance'] / 1000; // Convert to km
        final duration = route['duration'] / 60; // Convert to minutes

        setState(() {
          _routePoints = points;
          _routeInfo = 'Distance: ${distance.toStringAsFixed(2)} km\n'
              'Duration: ${duration.toStringAsFixed(0)} min';
          _isLoading = false;
        });

        _fitBounds();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _routeInfo = 'Error calculating route';
      });
    }
  }

  void _fitBounds() {
    if (_waypoints.isEmpty) return;

    double minLat = _waypoints.first.latitude;
    double maxLat = _waypoints.first.latitude;
    double minLng = _waypoints.first.longitude;
    double maxLng = _waypoints.first.longitude;

    for (var point in _waypoints) {
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

  void _addWaypoint(LatLng point) {
    setState(() {
      _waypoints.add(point);
    });
    _calculateRoute();
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;
    return Scaffold(
      backgroundColor: theme.screenBg,
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: Text('Route Planning', style: TextStyle(color: theme.white)),
        iconTheme: IconThemeData(color: theme.white),
        actions: [
          IconButton(
            icon: Icon(Icons.center_focus_strong, color: theme.white),
            onPressed: _fitBounds,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  _waypoints.isNotEmpty ? _waypoints.first : const LatLng(0, 0),
              initialZoom: 13.0,
              onTap: (tapPosition, point) => _addWaypoint(point),
            ),
            children: [
              OSMTileLayer(),
              // Route polyline
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: theme.activeColor,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
              // Waypoint markers
              MarkerLayer(
                markers: _waypoints.asMap().entries.map((entry) {
                  int index = entry.key;
                  LatLng point = entry.value;
                  bool isFirst = index == 0;
                  bool isLast = index == _waypoints.length - 1;

                  if (isLast) {
                    return MapMarkers.dropMarker(
                      point: point,
                      context: context,
                      onTap: null,
                    );
                  } else {
                    return MapMarkers.pickupMarker(
                      point: point,
                      number: isFirst ? 0 : index,
                      context: context,
                      onTap: null,
                    );
                  }
                }).toList(),
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
                color: theme.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Route Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.darkText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_routeInfo!,
                          style: TextStyle(color: theme.darkText)),
                      const SizedBox(height: 4),
                      Text(
                        'Waypoints: ${_waypoints.length}',
                        style: TextStyle(color: theme.lightText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Loading indicator
          if (_isLoading)
            Container(
              color: theme.darkText.withValues(alpha: 0.3),
              child: Center(
                child: CircularProgressIndicator(color: theme.primary),
              ),
            ),
          // Instructions
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              color: theme.bgBox,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 16, color: theme.activeColor),
                        const SizedBox(width: 8),
                        Text(
                          'Instructions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.darkText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('• Tap map to add waypoint',
                        style: TextStyle(fontSize: 12, color: theme.darkText)),
                    Text('• Long press marker to remove',
                        style: TextStyle(fontSize: 12, color: theme.darkText)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationPoint {
  final String name;
  final LatLng latLng;

  LocationPoint({required this.name, required this.latLng});
}
