import '../../config.dart';

class AddLocationProvider extends ChangeNotifier {
  MapController mapController = MapController();
  LatLng? position;
  String? address;
  Placemark? place;
  TextEditingController streetCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController zipCtrl = TextEditingController();
  TextEditingController areaCtrl = TextEditingController();
  dynamic country;
  dynamic state;

  // Dropdowns (unchanged)
  List dialogDropDownItems = [
    {'value': 1, 'label': 'Andhra Pradesh'},
    {'value': 2, 'label': 'Bihar'},
    {'value': 3, 'label': 'Gujarat'},
    {'value': 4, 'label': 'Karnataka'},
    {'value': 5, 'label': 'Madhya Pradesh'},
  ];
  List countryDialogDropDownItems = [
    {'value': 1, 'label': 'India'},
    {'value': 2, 'label': 'Switzerland'},
    {'value': 3, 'label': 'Japan'},
    {'value': 4, 'label': 'United States'},
    {'value': 5, 'label': 'Canada'},
  ];

  // Get current device location and update position
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;
      Position pos = await Geolocator.getCurrentPosition();
      position = LatLng(pos.latitude, pos.longitude);
      await getAddressFromLatLng(position!);
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  // Get address from LatLng
  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        place = placemarks.first;
        address =
            '${place!.street}, ${place!.locality}, ${place!.administrativeArea}, ${place!.country}';
        streetCtrl.text = place!.street ?? "";
        cityCtrl.text = place!.locality ?? '';
        zipCtrl.text = place!.postalCode ?? '';
        areaCtrl.text = place!.administrativeArea ?? '';
      }
      notifyListeners();
    } catch (e) {
      address = 'Could not get address';
      notifyListeners();
    }
  }

  // Called when the map is tapped (for flutter_map integration)
  void onMapTap(LatLng latLng) {
    position = latLng;
    getAddressFromLatLng(latLng);
    notifyListeners();
  }

  //country change value
  void countryChange(newValue) {
    country = newValue;
    notifyListeners();
  }

  //state change value
  void stateChange(newValue) {
    state = newValue;
    notifyListeners();
  }
}
