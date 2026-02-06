import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:provider/provider.dart';
import 'package:taxify_user_ui/provider/bottom_provider/trip_tracking_provider.dart';
import 'package:taxify_user_ui/widgets/maps/index.dart';

/// Widget for displaying real-time driver tracking on the map
class TrackingMapWidget extends StatefulWidget {
  const TrackingMapWidget({super.key});

  @override
  State<TrackingMapWidget> createState() => _TrackingMapWidgetState();
}

class _TrackingMapWidgetState extends State<TrackingMapWidget> {
  MapController? _mapController;
  bool _initialCentered = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _centerOnDriver(ll.LatLng position) {
    if (_mapController != null) {
      _mapController!.move(position, _mapController!.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripTrackingProvider>(
      builder: (context, tripCtrl, child) {
        final posData = tripCtrl.currentPositionData;
        final lat = posData['latitude'] as double?;
        final lng = posData['longitude'] as double?;

        // Show loading if no position yet
        if (lat == null || lng == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final driverLatLng = ll.LatLng(lat, lng);

        // Center on first position
        if (!_initialCentered && _mapController != null) {
          _initialCentered = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _centerOnDriver(driverLatLng);
          });
        }

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: driverLatLng,
            initialZoom: 15.0,
          ),
          children: [
            const MapTileLayer(),
            MarkerLayer(
              markers: [
                MapMarkers.driverLocationMarker(driverLatLng, context),
              ],
            ),
          ],
        );
      },
    );
  }
}
