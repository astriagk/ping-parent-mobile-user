import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:provider/provider.dart';
import 'package:skolo/api/enums/trip_type.dart';
import 'package:skolo/api/models/trip_tracking_response.dart';
import 'package:skolo/helper/location_service.dart';
import 'package:skolo/provider/bottom_provider/trip_tracking_provider.dart';
import 'package:skolo/widgets/maps/index.dart';

/// Widget for displaying real-time driver tracking on the map
class TrackingMapWidget extends StatefulWidget {
  final Trip? trip;
  final Waypoint? parentWaypoint;

  const TrackingMapWidget({super.key, this.trip, this.parentWaypoint});

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

        // Get driver position from websocket only
        ll.LatLng? driverLatLng;
        if (driverLat != null && driverLng != null) {
          driverLatLng = ll.LatLng(driverLat, driverLng);
        }

        // Center on driver when position is available
        if (!_initialCentered &&
            driverLatLng != null &&
            _mapController != null) {
          _initialCentered = true;
          final centerPosition = driverLatLng;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _centerOnDriver(centerPosition);
          });
        }

        // Pickup: full route. Drop: school waypoint → parent waypoint only.
        final polylinePoints = <ll.LatLng>[];
        final routeData = widget.trip?.optimizedRouteData;
        if (routeData != null) {
          if (widget.trip!.tripType == TripType.drop &&
              widget.parentWaypoint != null &&
              routeData.legs.isNotEmpty) {
            final waypoints = routeData.waypoints;
            final schoolIdx = waypoints.indexWhere(
                (w) => w.studentParentId == 'SCHOOL_LOCATION');
            final parentIdx = waypoints.indexWhere(
                (w) => w.parentUserId == widget.parentWaypoint!.parentUserId);
            // legs[i] covers the segment leading into waypoints[i].
            // Combine legs from schoolIdx+1 through parentIdx inclusive.
            final from = (schoolIdx >= 0 ? schoolIdx + 1 : 0);
            final to = parentIdx >= 0 ? parentIdx : routeData.legs.length - 1;
            for (int i = from; i <= to && i < routeData.legs.length; i++) {
              for (final coord in routeData.legs[i].coordinates) {
                polylinePoints.add(ll.LatLng(coord[0], coord[1]));
              }
            }
          } else {
            for (final coord in routeData.coordinates) {
              polylinePoints.add(ll.LatLng(coord[0], coord[1]));
            }
          }
        }

        // Get waypoints with markers
        final markersToShow = <Marker>[];

        if (widget.trip?.optimizedRouteData?.waypoints != null) {
          final waypoints = widget.trip!.optimizedRouteData!.waypoints;

          for (final waypoint in waypoints) {
            final waypointLatLng =
                ll.LatLng(waypoint.latitude, waypoint.longitude);

            final isSchool = waypoint.studentParentId == "SCHOOL_LOCATION";

            if (isSchool) {
              markersToShow.add(
                MapMarkers.dropOffMarker(waypointLatLng, context),
              );
            } else if (widget.parentWaypoint != null &&
                waypoint.parentUserId == widget.parentWaypoint!.parentUserId) {
              // Only show this parent's pickup point
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
