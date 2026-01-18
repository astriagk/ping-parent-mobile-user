import 'package:taxify_user_ui/widgets/maps/layout/osm_tile_layer.dart';
import 'package:taxify_user_ui/widgets/maps/map_markers.dart';

import '../../../../../config.dart';

class AddLocationWidgets {
  //google map layout
  Widget googleMapLayout() {
    return Consumer<AddLocationProvider>(
      builder: (context, locationCtrl, child) {
        if (locationCtrl.position == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final LatLng currentLatLng = LatLng(
          locationCtrl.position!.latitude,
          locationCtrl.position!.longitude,
        );
        return FlutterMap(
          mapController: locationCtrl.mapController,
          options: MapOptions(
            initialCenter: currentLatLng,
            initialZoom: 15.0,
            onTap: (tapPosition, latLng) {
              locationCtrl.onMapTap(latLng);
            },
          ),
          children: [
            OSMTileLayer(),
            MarkerLayer(
              markers: [
                MapMarkers.currentLocationMarker(
                  point: currentLatLng,
                  context: context,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
