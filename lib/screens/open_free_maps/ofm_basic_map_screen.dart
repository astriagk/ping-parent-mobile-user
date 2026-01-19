import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../common/openfreemap_config.dart';
import '../../widgets/open_free_maps/index.dart';

/// Basic OpenFreeMap example with user location
/// Shows how to display a simple map with current location marker
/// and multiple tile style options
class OFMBasicMapScreen extends StatefulWidget {
  const OFMBasicMapScreen({super.key});

  @override
  State<OFMBasicMapScreen> createState() => _OFMBasicMapScreenState();
}

class _OFMBasicMapScreenState extends State<OFMBasicMapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoading = true;
  int _selectedTileIndex = 0;
  String? _errorMessage;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location services are disabled';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Location permission denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location permission permanently denied';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Only move if map is already rendered
      if (_mapReady) {
        _mapController.move(_currentLocation!, 15.0);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error getting location: $e';
      });
    }
  }

  void _showTileSelector() {
    final tiles = OpenFreeMapConfig.allTileOptions;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Map Style',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                for (int i = 0; i < tiles.length; i++)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      i == _selectedTileIndex
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color:
                          i == _selectedTileIndex ? Colors.blue : Colors.grey,
                    ),
                    title: Text(
                      tiles[i]['name']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      tiles[i]['description']!,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    onTap: () {
                      setState(() => _selectedTileIndex = i);
                      Navigator.pop(context);
                    },
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Map'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _showTileSelector,
            tooltip: 'Map styles',
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _currentLocation != null
                ? () => _mapController.move(_currentLocation!, 15.0)
                : null,
            tooltip: 'My location',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : _buildMap(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    final tileUrl =
        OpenFreeMapConfig.allTileOptions[_selectedTileIndex]['url']!;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation ?? const LatLng(0, 0),
            initialZoom: 15.0,
            minZoom: OpenFreeMapConfig.minZoom,
            maxZoom: OpenFreeMapConfig.maxZoom,
            onMapReady: () {
              _mapReady = true;
            },
          ),
          children: [
            OFMTileLayer(urlTemplate: tileUrl),
            if (_currentLocation != null)
              MarkerLayer(
                markers: [
                  OFMMarkers.currentLocationMarker(_currentLocation!),
                ],
              ),
          ],
        ),
        // Tile info badge
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  OpenFreeMapConfig.allTileOptions[_selectedTileIndex]['name']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Map controls
        OFMMapControls(
          onZoomIn: () {
            final zoom = _mapController.camera.zoom;
            _mapController.move(_mapController.camera.center, zoom + 1);
          },
          onZoomOut: () {
            final zoom = _mapController.camera.zoom;
            _mapController.move(_mapController.camera.center, zoom - 1);
          },
          onMyLocation: _currentLocation != null
              ? () => _mapController.move(_currentLocation!, 15.0)
              : null,
          showLayersButton: true,
          onLayers: _showTileSelector,
        ),
      ],
    );
  }
}
