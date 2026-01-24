import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../common/tomtom_config.dart';

/// TomTom TileLayer widget
/// Reusable tile layer for displaying TomTom map tiles
class TTTileLayer extends StatelessWidget {
  /// Custom tile URL template (optional)
  /// If not provided, uses TomTomConfig.selectedTileUrl
  final String? urlTemplate;

  /// Optional key for forcing tile refresh
  final Key? tileKey;

  const TTTileLayer({
    this.urlTemplate,
    this.tileKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final url = urlTemplate ?? TomTomConfig.selectedTileUrl;

    return TileLayer(
      key: tileKey,
      urlTemplate: url,
      userAgentPackageName: TomTomConfig.userAgentPackageName,
      maxZoom: TomTomConfig.maxZoom,
    );
  }
}

/// Dark mode aware tile layer
/// Automatically switches between day and night tiles based on theme
class TTAdaptiveTileLayer extends StatelessWidget {
  /// Light theme tile URL (Basic Main)
  final String? lightTileUrl;

  /// Dark theme tile URL (Basic Night)
  final String? darkTileUrl;

  const TTAdaptiveTileLayer({
    this.lightTileUrl,
    this.darkTileUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final url = isDark
        ? (darkTileUrl ?? TomTomConfig.allTileOptions[1]['url']!) // Basic Night
        : (lightTileUrl ?? TomTomConfig.selectedTileUrl);

    return TTTileLayer(urlTemplate: url);
  }
}
