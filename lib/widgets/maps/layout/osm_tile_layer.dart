import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../common/config.dart';

/// Reusable OSM TileLayer widget for FlutterMap
class OSMTileLayer extends StatelessWidget {
  final Key? tileKey;
  final double? opacity;
  final List<Widget>? children;

  const OSMTileLayer({
    this.tileKey,
    this.opacity,
    this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      key: tileKey,
      urlTemplate: AppConfig.osmTileUrl,
      userAgentPackageName: AppConfig.userAgentPackageName,
    );
  }
}
