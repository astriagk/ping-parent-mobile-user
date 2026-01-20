import 'package:taxify_user_ui/widgets/maps/layout/osm_tile_layer.dart';
import 'package:taxify_user_ui/widgets/map_common/markers.dart';

import '../../config.dart';

/// Multi-marker map example
/// Shows multiple pickup/drop locations with different colored markers
class MultiMarkerMapScreen extends StatefulWidget {
  const MultiMarkerMapScreen({super.key});

  @override
  State<MultiMarkerMapScreen> createState() => _MultiMarkerMapScreenState();
}

class _MultiMarkerMapScreenState extends State<MultiMarkerMapScreen> {
  final MapController _mapController = MapController();

  // Example: Multiple pickup locations
  final List<MapLocation> _pickupLocations = [
    MapLocation(
      latLng: const LatLng(37.7749, -122.4194),
      title: 'Pickup 1',
      subtitle: 'San Francisco',
      type: LocationType.pickup,
    ),
    MapLocation(
      latLng: const LatLng(37.7849, -122.4094),
      title: 'Pickup 2',
      subtitle: 'North Beach',
      type: LocationType.pickup,
    ),
    MapLocation(
      latLng: const LatLng(37.7649, -122.4294),
      title: 'Pickup 3',
      subtitle: 'Mission District',
      type: LocationType.pickup,
    ),
  ];

  // Example: Single drop location
  final MapLocation _dropLocation = MapLocation(
    latLng: const LatLng(37.7949, -122.3994),
    title: 'Drop Point',
    subtitle: 'Destination',
    type: LocationType.drop,
  );

  int? _selectedMarkerIndex;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;
    return Scaffold(
      backgroundColor: theme.screenBg,
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: Text('Multi-Marker Map', style: TextStyle(color: theme.white)),
        iconTheme: IconThemeData(color: theme.white),
        actions: [
          IconButton(
            icon: Icon(Icons.center_focus_strong, color: theme.white),
            onPressed: _fitBounds,
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _pickupLocations.first.latLng,
          initialZoom: 13.0,
        ),
        children: [
          OSMTileLayer(),
          MarkerLayer(
            markers: [
              // Pickup markers (green)
              ..._pickupLocations.asMap().entries.map((entry) {
                int index = entry.key;
                MapLocation loc = entry.value;
                return MapMarkers.pickupMarker(
                  loc.latLng,
                  context,
                  onTap: () => _onMarkerTap(index),
                );
              }),
              // Drop marker (red)
              MapMarkers.dropMarker(_dropLocation.latLng, context),
            ],
          ),
          // Draw polyline connecting all locations
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  ..._pickupLocations.map((loc) => loc.latLng),
                  _dropLocation.latLng,
                ],
                color: theme.activeColor,
                strokeWidth: 3.0,
              ),
            ],
          ),
        ],
      ),
      bottomSheet: _selectedMarkerIndex != null
          ? _buildLocationInfo(context, _pickupLocations[_selectedMarkerIndex!])
          : null,
    );
  }

  Widget _buildLocationInfo(BuildContext context, MapLocation location) {
    final theme = appColor(context).appTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.white,
        boxShadow: [
          BoxShadow(
            color: theme.darkText.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            location.type == LocationType.pickup
                ? Icons.location_on
                : Icons.flag,
            color: location.type == LocationType.pickup
                ? theme.success
                : theme.alertZone,
            size: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  location.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.darkText,
                  ),
                ),
                Text(
                  location.subtitle,
                  style: TextStyle(color: theme.lightText),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: theme.darkText),
            onPressed: () => setState(() => _selectedMarkerIndex = null),
          ),
        ],
      ),
    );
  }

  void _onMarkerTap(int index) {
    setState(() {
      _selectedMarkerIndex = index;
    });
    _mapController.move(_pickupLocations[index].latLng, 15.0);
  }

  void _fitBounds() {
    // Calculate bounds to show all markers
    final allPoints = [
      ..._pickupLocations.map((loc) => loc.latLng),
      _dropLocation.latLng,
    ];

    if (allPoints.isEmpty) return;

    double minLat = allPoints.first.latitude;
    double maxLat = allPoints.first.latitude;
    double minLng = allPoints.first.longitude;
    double maxLng = allPoints.first.longitude;

    for (var point in allPoints) {
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
}

// Data models
class MapLocation {
  final LatLng latLng;
  final String title;
  final String subtitle;
  final LocationType type;

  MapLocation({
    required this.latLng,
    required this.title,
    required this.subtitle,
    required this.type,
  });
}

enum LocationType {
  pickup,
  drop,
}
