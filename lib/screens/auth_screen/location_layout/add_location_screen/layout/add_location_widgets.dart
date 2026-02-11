import 'package:taxify_user_ui/widgets/maps/index.dart';

import '../../../../../config.dart';

class AddLocationWidgets {
  //map layout
  Widget mapLayout() {
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
            const MapTileLayer(),
            MarkerLayer(
              markers: [
                MapMarkers.currentLocationMarker(currentLatLng, context),
              ],
            ),
          ],
        );
      },
    );
  }
}
