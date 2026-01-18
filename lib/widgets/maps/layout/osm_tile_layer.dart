import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../common/map_config.dart';

/// Reusable OSM TileLayer widget for FlutterMap

class OSMTileLayer extends StatelessWidget {
  final String? urlTemplate;
  final Key? tileKey;
  final double? opacity;
  final List<Widget>? children;

  const OSMTileLayer({
    this.urlTemplate,
    this.tileKey,
    this.opacity,
    this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultUrl = MapConfig.osmTileOptions.first['url']!;
    return TileLayer(
      key: tileKey,
      urlTemplate: urlTemplate ?? defaultUrl,
      userAgentPackageName: MapConfig.userAgentPackageName,
    );
  }
}
