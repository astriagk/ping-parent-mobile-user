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

  // Indian states dropdown (ISO 3166-2:IN codes)
  List dialogDropDownItems = [
    {'value': 'AP', 'label': 'Andhra Pradesh'},
    {'value': 'AR', 'label': 'Arunachal Pradesh'},
    {'value': 'AS', 'label': 'Assam'},
    {'value': 'BR', 'label': 'Bihar'},
    {'value': 'CG', 'label': 'Chhattisgarh'},
    {'value': 'GA', 'label': 'Goa'},
    {'value': 'GJ', 'label': 'Gujarat'},
    {'value': 'HR', 'label': 'Haryana'},
    {'value': 'HP', 'label': 'Himachal Pradesh'},
    {'value': 'JH', 'label': 'Jharkhand'},
    {'value': 'KA', 'label': 'Karnataka'},
    {'value': 'KL', 'label': 'Kerala'},
    {'value': 'MP', 'label': 'Madhya Pradesh'},
    {'value': 'MH', 'label': 'Maharashtra'},
    {'value': 'MN', 'label': 'Manipur'},
    {'value': 'ML', 'label': 'Meghalaya'},
    {'value': 'MZ', 'label': 'Mizoram'},
    {'value': 'NL', 'label': 'Nagaland'},
    {'value': 'OD', 'label': 'Odisha'},
    {'value': 'PB', 'label': 'Punjab'},
    {'value': 'RJ', 'label': 'Rajasthan'},
    {'value': 'SK', 'label': 'Sikkim'},
    {'value': 'TN', 'label': 'Tamil Nadu'},
    {'value': 'TS', 'label': 'Telangana'},
    {'value': 'TR', 'label': 'Tripura'},
    {'value': 'UP', 'label': 'Uttar Pradesh'},
    {'value': 'UK', 'label': 'Uttarakhand'},
    {'value': 'WB', 'label': 'West Bengal'},
    {'value': 'DL', 'label': 'Delhi'},
    {'value': 'JK', 'label': 'Jammu and Kashmir'},
    {'value': 'LA', 'label': 'Ladakh'},
    {'value': 'PY', 'label': 'Puducherry'},
    {'value': 'CH', 'label': 'Chandigarh'},
  ];

  // Country dropdown (ISO 3166-1 alpha-2 codes)
  List countryDialogDropDownItems = [
    {'value': 'IN', 'label': 'India'},
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

        // Reset country and state
        country = null;
        state = null;

        // Use isoCountryCode directly if available, otherwise match by label
        final isoCountry = place!.isoCountryCode?.toUpperCase();
        if (isoCountry != null) {
          final countryExists = countryDialogDropDownItems
              .any((item) => item['value'] == isoCountry);
          if (countryExists) {
            country = isoCountry;
          }
        }

        // Match state by label name (case-insensitive)
        final stateName = place!.administrativeArea ?? '';
        if (stateName.isNotEmpty) {
          for (var item in dialogDropDownItems) {
            if (item['label'].toString().toLowerCase() ==
                stateName.toLowerCase()) {
              state = item['value'];
              break;
            }
          }
        }
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
