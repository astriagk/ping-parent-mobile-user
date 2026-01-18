import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'layout/osm_tile_layer.dart';

/// Reusable map widget with customizable options
class CustomMapWidget extends StatelessWidget {
  final MapController? controller;
  final LatLng initialCenter;
  final double initialZoom;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final Function(TapPosition, LatLng)? onTap;
  final void Function(MapCamera, bool)? onPositionChanged;
  final bool showUserLocation;
  final Widget? overlayWidget;

  const CustomMapWidget({
    super.key,
    this.controller,
    required this.initialCenter,
    this.initialZoom = 15.0,
    this.markers = const [],
    this.polylines = const [],
    this.onTap,
    this.onPositionChanged,
    this.showUserLocation = false,
    this.overlayWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        minZoom: 5.0,
        maxZoom: 18.0,
        onTap: onTap,
        onPositionChanged: onPositionChanged,
      ),
      children: [
        OSMTileLayer(),
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        if (markers.isNotEmpty) MarkerLayer(markers: markers),
        if (overlayWidget != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: overlayWidget!,
          ),
      ],
    );
  }
}
