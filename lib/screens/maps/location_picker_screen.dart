import 'package:taxify_user_ui/widgets/maps/layout/osm_tile_layer.dart';
import 'package:taxify_user_ui/widgets/maps/map_markers.dart';

import '../../config.dart';

/// Interactive location picker with draggable marker
/// User can drag marker to select a location and get the address
class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final MapController _mapController = MapController();
  LatLng _selectedLocation = const LatLng(0, 0);
  String _address = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _address = 'Location services disabled';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      await _getAddressFromLatLng(_selectedLocation);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _address = 'Error getting location';
      });
    }
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _address =
              '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Could not get address';
      });
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _getAddressFromLatLng(location);
  }

  void _confirmLocation() {
    Navigator.pop(context, {
      'latitude': _selectedLocation.latitude,
      'longitude': _selectedLocation.longitude,
      'address': _address,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;
    return Scaffold(
      backgroundColor: theme.screenBg,
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: Text('Pick Location', style: TextStyle(color: theme.white)),
        iconTheme: IconThemeData(color: theme.white),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location, color: theme.white),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation,
                    initialZoom: 15.0,
                    onTap: _onMapTap,
                  ),
                  children: [
                    OSMTileLayer(),
                    MarkerLayer(
                      markers: [
                        MapMarkers.currentLocationMarker(
                          point: _selectedLocation,
                          context: context,
                        ),
                      ],
                    ),
                  ],
                ),
                // Address display
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Selected Location:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.darkText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(_address,
                              style: TextStyle(color: theme.darkText)),
                          const SizedBox(height: 4),
                          Text(
                            'Lat: ${_selectedLocation.latitude.toStringAsFixed(6)}, '
                            'Lng: ${_selectedLocation.longitude.toStringAsFixed(6)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Confirm button
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      foregroundColor: theme.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Confirm Location',
                        style: TextStyle(color: theme.white)),
                  ),
                ),
              ],
            ),
    );
  }
}
