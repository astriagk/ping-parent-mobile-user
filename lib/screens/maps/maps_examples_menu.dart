import 'package:taxify_user_ui/common/maps/map_config.dart';
import 'package:taxify_user_ui/config.dart' hide Marker, Polyline, LatLng;
import 'package:taxify_user_ui/widgets/maps/layout/map_tile_layer.dart';
import 'package:taxify_user_ui/widgets/maps/map_widget.dart';

/// Map Example Screen - Main Map Screen
/// Tiles with MapWidget
class MapExampleScreen extends StatelessWidget {
  const MapExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = MapProvidersRegistry.getConfig();
    return MapWidget(
      config: config,
      tileLayerBuilder: (urlTemplate) => MapTileLayer(
        urlTemplate: urlTemplate,
      ),
      showControls: true,
    );
  }
}
