import '../../config.dart';
import '../../api/api_client.dart';
import '../../api/services/address_service.dart';

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

  // API state
  bool _isSaving = false;
  String? _errorMessage;

  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  // Formatted address: number, street, area, city, state, pincode
  // Example: 24 & 25, 1st Cross Road, Azad Nagar, Bengaluru, KA, 560026
  String get formattedAddress {
    final parts = <String>[];

    // Building number (subThoroughfare)
    if (place?.subThoroughfare?.isNotEmpty == true) {
      parts.add(place!.subThoroughfare!);
    }

    // Street name (thoroughfare)
    if (place?.thoroughfare?.isNotEmpty == true) {
      parts.add(place!.thoroughfare!);
    }

    // Area (subLocality)
    if (place?.subLocality?.isNotEmpty == true) {
      parts.add(place!.subLocality!);
    }

    // City (locality)
    if (place?.locality?.isNotEmpty == true) {
      parts.add(place!.locality!);
    }

    // State (use the code like KA)
    if (state != null && state.toString().isNotEmpty) {
      parts.add(state.toString());
    }

    // Pincode
    if (place?.postalCode?.isNotEmpty == true) {
      parts.add(place!.postalCode!);
    }

    return parts.join(', ');
  }

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

        // Map Placemark fields to text controllers:
        // streetCtrl: building number + street name (subThoroughfare + thoroughfare)
        final streetParts = <String>[];
        if (place!.subThoroughfare?.isNotEmpty == true) {
          streetParts.add(place!.subThoroughfare!);
        }
        if (place!.thoroughfare?.isNotEmpty == true) {
          streetParts.add(place!.thoroughfare!);
        }
        streetCtrl.text = streetParts.isNotEmpty
            ? streetParts.join(', ')
            : (place!.street ?? '');

        // areaCtrl: subLocality (area/neighborhood)
        areaCtrl.text = place!.subLocality ?? '';

        // cityCtrl: locality (city)
        cityCtrl.text = place!.locality ?? '';

        // zipCtrl: postalCode (pincode)
        zipCtrl.text = place!.postalCode ?? '';

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

  // Construct address_line1: use streetCtrl value (user can edit this)
  String get addressLine1 {
    return streetCtrl.text;
  }

  // Construct address_line2: use areaCtrl value (user can edit this)
  String get addressLine2 {
    return areaCtrl.text;
  }

  // Validate required fields
  String? validateAddress() {
    if (streetCtrl.text.isEmpty) {
      return 'Street address is required';
    }
    if (cityCtrl.text.isEmpty) {
      return 'City is required';
    }
    if (state == null || state.toString().isEmpty) {
      return 'State is required';
    }
    if (position == null) {
      return 'Location coordinates are required';
    }
    return null;
  }

  // Save address to API
  Future<bool> saveAddress() async {
    // Validate
    final validationError = validateAddress();
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final addressService = AddressService(ApiClient());
      final result = await addressService.saveAddress(
        addressLine1: streetCtrl.text,
        addressLine2: areaCtrl.text,
        city: cityCtrl.text,
        state: state.toString(),
        pincode: zipCtrl.text,
        latitude: position!.latitude,
        longitude: position!.longitude,
        isPrimary: true,
      );

      _isSaving = false;

      if (result['success'] == true) {
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'] ?? 'Failed to save address';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isSaving = false;
      _errorMessage = 'Error saving address: $e';
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
