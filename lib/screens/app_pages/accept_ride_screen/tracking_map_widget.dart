import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:provider/provider.dart';
import 'package:taxify_user_ui/api/models/trip_tracking_response.dart';
import 'package:taxify_user_ui/helper/location_service.dart';
import 'package:taxify_user_ui/provider/bottom_provider/trip_tracking_provider.dart';
import 'package:taxify_user_ui/widgets/maps/index.dart';

/// Widget for displaying real-time driver tracking on the map
class TrackingMapWidget extends StatefulWidget {
  final Trip? trip;

  const TrackingMapWidget({super.key, this.trip});

  @override
  State<TrackingMapWidget> createState() => _TrackingMapWidgetState();
}

class _TrackingMapWidgetState extends State<TrackingMapWidget> {
  MapController? _mapController;
  bool _initialCentered = false;
  ll.LatLng? _userLocation;
  bool _loadingUserLocation = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final location = await LocationService.getCurrentLocation();
      setState(() {
        _userLocation = location;
        _loadingUserLocation = false;
      });
    } catch (e) {
      setState(() {
        _loadingUserLocation = false;
      });
    }
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
        final driverLat = posData['latitude'] as double?;
        final driverLng = posData['longitude'] as double?;
        final driverHeading = (posData['heading'] as num?)?.toDouble() ?? 0.0;

        // Show loading while getting user location
        if (_loadingUserLocation) {
          return const Center(child: CircularProgressIndicator());
        }

        // Use user location or default if not available
        final mapCenter = _userLocation ?? ll.LatLng(20.0, 0.0);
        final driverLatLng = driverLat != null && driverLng != null
            ? ll.LatLng(driverLat, driverLng)
            : null;

        // Center on driver when position is available
        if (!_initialCentered &&
            driverLatLng != null &&
            _mapController != null) {
          _initialCentered = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _centerOnDriver(driverLatLng);
          });
        }

        // Build polyline from trip coordinates
        final polylinePoints = <ll.LatLng>[];
        if (widget.trip?.optimizedRouteData?.coordinates != null) {
          for (final coord in widget.trip!.optimizedRouteData!.coordinates) {
            polylinePoints.add(ll.LatLng(coord[0], coord[1]));
          }
        }

        // Get waypoints with markers
        final markersToShow = <Marker>[];

        if (widget.trip?.optimizedRouteData?.waypoints != null) {
          final waypoints = widget.trip!.optimizedRouteData!.waypoints;

          for (final waypoint in waypoints) {
            final waypointLatLng =
                ll.LatLng(waypoint.latitude, waypoint.longitude);

            final isSchoolLocation =
                waypoint.studentParentId == "SCHOOL_LOCATION";

            if (isSchoolLocation) {
              // School/dropoff location
              markersToShow.add(
                MapMarkers.dropOffMarker(waypointLatLng, context),
              );
            } else {
              // Pickup location (any non-school waypoint)
              markersToShow.add(
                MapMarkers.pickupMarker(waypointLatLng, context),
              );
            }
          }
        }

        // Add driver location marker
        if (driverLatLng != null) {
          markersToShow.add(
            MapMarkers.driverLocationMarker(driverLatLng, context,
                heading: driverHeading),
          );
        }

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: mapCenter,
            initialZoom: 15.0,
          ),
          children: [
            const MapTileLayer(),
            // Draw polyline for the route
            if (polylinePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  RoutePolylines.activeRoute(polylinePoints, context),
                ],
              ),
            // Draw markers
            MarkerLayer(markers: markersToShow),
          ],
        );
      },
    );
  }
}
