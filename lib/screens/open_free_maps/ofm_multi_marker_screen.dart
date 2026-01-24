import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../widgets/open_free_maps/index.dart';

/// Multi-marker map example
/// Shows multiple pickup/drop locations with different colored markers
/// Demonstrates polylines connecting locations and marker interactions
class OFMMultiMarkerScreen extends StatefulWidget {
  const OFMMultiMarkerScreen({super.key});

  @override
  State<OFMMultiMarkerScreen> createState() => _OFMMultiMarkerScreenState();
}

class _OFMMultiMarkerScreenState extends State<OFMMultiMarkerScreen> {
  final MapController _mapController = MapController();
  bool _mapReady = false;

  // Example: Multiple pickup locations
  final List<OFMLocation> _pickupLocations = [
    OFMLocation(
      latLng: const LatLng(37.7749, -122.4194),
      title: 'Pickup 1',
      subtitle: 'Downtown San Francisco',
      type: OFMLocationType.pickup,
    ),
    OFMLocation(
      latLng: const LatLng(37.7849, -122.4094),
      title: 'Pickup 2',
      subtitle: 'North Beach',
      type: OFMLocationType.pickup,
    ),
    OFMLocation(
      latLng: const LatLng(37.7649, -122.4294),
      title: 'Pickup 3',
      subtitle: 'Mission District',
      type: OFMLocationType.pickup,
    ),
  ];

  // Example: Single drop location
  final OFMLocation _dropLocation = OFMLocation(
    latLng: const LatLng(37.7949, -122.3994),
    title: 'Drop Point',
    subtitle: 'Embarcadero Center',
    type: OFMLocationType.drop,
  );

  int? _selectedMarkerIndex;

  @override
  void initState() {
    super.initState();
  }

  void _onMarkerTap(int index) {
    setState(() {
      _selectedMarkerIndex = index;
    });
    if (_mapReady) {
      _mapController.move(_pickupLocations[index].latLng, 15.0);
    }
  }

  void _onDropMarkerTap() {
    setState(() {
      _selectedMarkerIndex = null;
    });
    _showLocationInfo(_dropLocation);
  }

  void _showLocationInfo(OFMLocation location) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: location.type == OFMLocationType.pickup
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    location.type == OFMLocationType.pickup
                        ? Icons.location_on
                        : Icons.flag,
                    color: location.type == OFMLocationType.pickup
                        ? Colors.green
                        : Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        location.subtitle,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Lat: ${location.latLng.latitude.toStringAsFixed(6)}, '
              'Lng: ${location.latLng.longitude.toStringAsFixed(6)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (_mapReady) {
                    _mapController.move(location.latLng, 16.0);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Center on Map'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fitBounds() {
    if (!_mapReady) return;
    final allPoints = [
      ..._pickupLocations.map((loc) => loc.latLng),
      _dropLocation.latLng,
    ];
    MapUtils.fitBounds(_mapController, allPoints);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Marker Map'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: _fitBounds,
            tooltip: 'Fit all markers',
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _pickupLocations.first.latLng,
              initialZoom: 13.0,
              onMapReady: () {
                _mapReady = true;
                _fitBounds();
              },
            ),
            children: [
              const OFMTileLayer(),
              // Polyline connecting all locations
              PolylineLayer(
                polylines: [
                  MapPolylines.activeRoute(
                    [
                      ..._pickupLocations.map((loc) => loc.latLng),
                      _dropLocation.latLng,
                    ],
                    context,
                  ),
                ],
              ),
              // Markers
              MarkerLayer(
                markers: [
                  // Numbered pickup markers
                  ..._pickupLocations.asMap().entries.map((entry) {
                    int index = entry.key;
                    OFMLocation loc = entry.value;
                    return MapMarkers.numberedMarker(
                      loc.latLng,
                      context,
                      number: index + 1,
                      color: Colors.green.shade700,
                      onTap: () => _onMarkerTap(index),
                    );
                  }),
                  // Drop marker
                  MapMarkers.dropMarker(
                    _dropLocation.latLng,
                    context,
                    onTap: _onDropMarkerTap,
                  ),
                ],
              ),
            ],
          ),
          // Legend
          Positioned(
            top: 16,
            left: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Route Stops',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._pickupLocations.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.green.shade700,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry.value.title,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flag, color: Colors.red.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _dropLocation.title,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Selected marker info
          if (_selectedMarkerIndex != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
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
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${_selectedMarkerIndex! + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _pickupLocations[_selectedMarkerIndex!].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _pickupLocations[_selectedMarkerIndex!].subtitle,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            setState(() => _selectedMarkerIndex = null),
                      ),
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

// Data models
class OFMLocation {
  final LatLng latLng;
  final String title;
  final String subtitle;
  final OFMLocationType type;

  OFMLocation({
    required this.latLng,
    required this.title,
    required this.subtitle,
    required this.type,
  });
}

enum OFMLocationType {
  pickup,
  drop,
}
