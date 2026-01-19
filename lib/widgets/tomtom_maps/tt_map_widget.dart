import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../common/tomtom_config.dart';
import 'layout/tt_tile_layer.dart';

/// Reusable TomTom Map widget with customizable options
/// Provides a complete map solution with markers, polylines, and interactions
class TTMapWidget extends StatelessWidget {
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

  /// Whether to use adaptive day/night tiles
  final bool adaptiveTiles;

  /// Additional child widgets (overlays)
  final List<Widget> overlayWidgets;

  /// Interaction options
  final InteractionOptions? interactionOptions;

  /// Callback when map is ready
  final VoidCallback? onMapReady;

  const TTMapWidget({
    super.key,
    this.controller,
    required this.initialCenter,
    this.initialZoom = TomTomConfig.defaultZoom,
    this.minZoom = TomTomConfig.minZoom,
    this.maxZoom = TomTomConfig.maxZoom,
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
    this.onMapReady,
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
        onMapReady: onMapReady,
        interactionOptions: interactionOptions ??
            const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
      ),
      children: [
        // Tile layer
        if (adaptiveTiles)
          const TTAdaptiveTileLayer()
        else
          TTTileLayer(urlTemplate: tileUrl),

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

/// Simple TomTom map widget with minimal configuration
class TTSimpleMap extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final List<Marker> markers;

  const TTSimpleMap({
    super.key,
    required this.center,
    this.zoom = 15.0,
    this.markers = const [],
  });

  @override
  Widget build(BuildContext context) {
    return TTMapWidget(
      initialCenter: center,
      initialZoom: zoom,
      markers: markers,
    );
  }
}
