import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../common/openfreemap_config.dart';

/// OpenFreeMap TileLayer widget
/// Reusable tile layer for displaying map tiles
class OFMTileLayer extends StatelessWidget {
  /// Custom tile URL template (optional)
  /// If not provided, uses OpenFreeMapConfig.selectedTileUrl
  final String? urlTemplate;

  /// Optional key for forcing tile refresh
  final Key? tileKey;

  const OFMTileLayer({
    this.urlTemplate,
    this.tileKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final url = urlTemplate ?? OpenFreeMapConfig.selectedTileUrl;

    return TileLayer(
      key: tileKey,
      urlTemplate: url,
      userAgentPackageName: OpenFreeMapConfig.userAgentPackageName,
      maxZoom: OpenFreeMapConfig.maxZoom,
    );
  }
}

/// Dark mode aware tile layer
/// Automatically switches between light and dark tiles based on theme
class OFMAdaptiveTileLayer extends StatelessWidget {
  /// Light theme tile URL
  final String? lightTileUrl;

  /// Dark theme tile URL
  final String? darkTileUrl;

  const OFMAdaptiveTileLayer({
    this.lightTileUrl,
    this.darkTileUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final url = isDark
        ? (darkTileUrl ??
            'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png')
        : (lightTileUrl ?? OpenFreeMapConfig.selectedTileUrl);

    return OFMTileLayer(urlTemplate: url);
  }
}
