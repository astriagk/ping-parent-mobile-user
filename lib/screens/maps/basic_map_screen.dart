import 'package:taxify_user_ui/widgets/maps/layout/osm_tile_layer.dart';
import 'package:taxify_user_ui/widgets/maps/map_markers.dart';

import '../../config.dart';
import 'package:taxify_user_ui/common/map_config.dart';

/// Basic OpenStreetMap example with user location
/// Shows how to display a simple map with current location marker
class BasicMapScreen extends StatefulWidget {
  const BasicMapScreen({super.key});

  @override
  State<BasicMapScreen> createState() => _BasicMapScreenState();
}

class _BasicMapScreenState extends State<BasicMapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoading = true;
  int _selectedTileIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoading = false);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Move map to current location
      _mapController.move(_currentLocation!, 15.0);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;
    final tileOptions = MapConfig.osmTileOptions;
    return Scaffold(
      backgroundColor: theme.screenBg,
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: Text('Basic Map Example', style: TextStyle(color: theme.white)),
        iconTheme: IconThemeData(color: theme.white),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location, color: theme.white),
            onPressed: _currentLocation != null
                ? () => _mapController.move(_currentLocation!, 15.0)
                : null,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text('Map Style:',
                          style: TextStyle(color: theme.darkText)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButton<int>(
                          value: _selectedTileIndex,
                          isExpanded: true,
                          items: List.generate(
                            tileOptions.length,
                            (i) => DropdownMenuItem(
                              value: i,
                              child: Text(tileOptions[i]['name']!),
                            ),
                          ),
                          onChanged: (i) {
                            if (i != null)
                              setState(() => _selectedTileIndex = i);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLocation ?? const LatLng(0, 0),
                      initialZoom: 15.0,
                      minZoom: 5.0,
                      maxZoom: 18.0,
                    ),
                    children: [
                      OSMTileLayer(
                          urlTemplate: tileOptions[_selectedTileIndex]['url']!),
                      if (_currentLocation != null)
                        MarkerLayer(
                          markers: [
                            MapMarkers.currentLocationMarker(
                              point: _currentLocation!,
                              context: context,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
