import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../common/openfreemap_config.dart';
import 'layout/ofm_tile_layer.dart';

/// Reusable OpenFreeMap widget with customizable options
/// Provides a complete map solution with markers, polylines, and interactions
class OFMMapWidget extends StatelessWidget {
  /// Map controller for programmatic control
  final MapController? controller;

  /// Initial center position
  final LatLng initialCenter;

  /// Initial zoom level
  final double initialZoom;

  /// Minimum zoom level
  final double minZoom;

  /// Maximum zoom level
  final double maxZoom;

  /// List of markers to display
  final List<Marker> markers;

  /// List of polylines to display
  final List<Polyline> polylines;

  /// List of polygons to display
  final List<Polygon> polygons;

  /// List of circles to display
  final List<CircleMarker> circles;

  /// Callback when map is tapped
  final Function(TapPosition, LatLng)? onTap;

  /// Callback when map is long pressed
  final Function(TapPosition, LatLng)? onLongPress;

  /// Callback when map position changes
  final void Function(MapCamera, bool)? onPositionChanged;

  /// Custom tile URL (optional)
  final String? tileUrl;

  /// Whether to use adaptive dark/light tiles
  final bool adaptiveTiles;

  /// Additional child widgets (overlays)
  final List<Widget> overlayWidgets;

  /// Interaction options
  final InteractionOptions? interactionOptions;

  const OFMMapWidget({
    super.key,
    this.controller,
    required this.initialCenter,
    this.initialZoom = OpenFreeMapConfig.defaultZoom,
    this.minZoom = OpenFreeMapConfig.minZoom,
    this.maxZoom = OpenFreeMapConfig.maxZoom,
    this.markers = const [],
    this.polylines = const [],
    this.polygons = const [],
    this.circles = const [],
    this.onTap,
    this.onLongPress,
    this.onPositionChanged,
    this.tileUrl,
    this.adaptiveTiles = false,
    this.overlayWidgets = const [],
    this.interactionOptions,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        minZoom: minZoom,
        maxZoom: maxZoom,
        onTap: onTap,
        onLongPress: onLongPress,
        onPositionChanged: onPositionChanged,
        interactionOptions: interactionOptions ??
            const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
      ),
      children: [
        // Tile layer
        if (adaptiveTiles)
          const OFMAdaptiveTileLayer()
        else
          OFMTileLayer(urlTemplate: tileUrl),

        // Polygons layer
        if (polygons.isNotEmpty) PolygonLayer(polygons: polygons),

        // Polylines layer
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),

        // Circles layer
        if (circles.isNotEmpty) CircleLayer(circles: circles),

        // Markers layer
        if (markers.isNotEmpty) MarkerLayer(markers: markers),

        // Additional overlay widgets
        ...overlayWidgets,
      ],
    );
  }
}

/// Simple map widget with minimal configuration
class OFMSimpleMap extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final List<Marker> markers;

  const OFMSimpleMap({
    super.key,
    required this.center,
    this.zoom = 15.0,
    this.markers = const [],
  });

  @override
  Widget build(BuildContext context) {
    return OFMMapWidget(
      initialCenter: center,
      initialZoom: zoom,
      markers: markers,
    );
  }
}
