import '../../../../../config.dart';

class AddLocationWidgets {
  //google map layout
  Widget googleMapLayout() {
    return Consumer<AddLocationProvider>(
        builder: (context, locationCtrl, child) {
      return GoogleMap(
          buildingsEnabled: false,
          zoomGesturesEnabled: true,
          myLocationButtonEnabled: true,
          fortyFiveDegreeImageryEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
              target: LatLng(locationCtrl.position!.latitude,
                  locationCtrl.position!.longitude),
              zoom: 15),
          markers: locationCtrl.marker ?? {},
          mapType: MapType.normal,
          onMapCreated: (controller) => locationCtrl.onController(controller));
    });
  }
}
