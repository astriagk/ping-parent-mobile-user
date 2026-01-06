import 'dart:developer';
import 'package:location/location.dart' as location_package;

import '../../config.dart';

class AddLocationProvider extends ChangeNotifier {
  GoogleMapController? mapController;
  location_package.Location location = location_package.Location();
  Set<Marker>? marker;
  Position? position, currentPosition;
  TextEditingController streetCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController zipCtrl = TextEditingController();
  TextEditingController areaCtrl = TextEditingController();
  double? newLog, newLat;
  Placemark? place;
  String? currentAddress, street;
  double? prevLat, prevLon;
  dynamic country;
  dynamic state;

  //select card number dropDown layout
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

// map controller
  onController(controller) {
    mapController = controller;
    notifyListeners();
  }

// get current location
  currentLocation() async {
    mapController!.animateCamera(CameraUpdate.newLatLng(
        LatLng(currentPosition!.latitude, currentPosition!.longitude)));
    newLat = null;
    newLog = null;
    position = currentPosition;
    notifyListeners();
    getCurrentPosition();
  }

//get current position
  getCurrentPosition() async {
    await Geolocator.requestPermission().then((value) async {
      Position position1 = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      position = position1;
      currentPosition = position1;
      notifyListeners();
      getAddressFromLatLng();
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      log("ERROR $error");
    });
  }

// get address from latLong
  getAddressFromLatLng() async {
    await placemarkFromCoordinates(
      newLat ?? position?.latitude ?? 0.0,
      newLog ?? position?.longitude ?? 0.0,
    ).then((List<Placemark> placeMarks) async {
      place = placeMarks[0];
      marker = {};
      log("place : ${placeMarks[0]}");
      currentAddress = place!.name;
      street =
          '${place!.name}, ${place!.street}, ${place!.subLocality}, ${place!.locality}, ${place!.postalCode}';
      streetCtrl.text = place!.street ?? "";
      cityCtrl.text = place!.subLocality ?? '';
      zipCtrl.text = place!.postalCode ?? '';
      areaCtrl.text = place!.locality ?? '';
      marker!.add(Marker(
          draggable: true,
          onDragEnd: (value) {
            newLat = value.latitude;
            newLog = value.longitude;
            if (newLat != null && newLog != null) {
              position = Position(
                  latitude: newLat!,
                  longitude: newLog!,
                  timestamp: DateTime.now(),
                  accuracy: 0.0,
                  altitude: 0.0,
                  altitudeAccuracy: 0.0,
                  heading: 0.0,
                  headingAccuracy: 0.0,
                  speed: 0.0,
                  speedAccuracy: 0.0);
              getAddressFromLatLng();
            }
            notifyListeners();
          },
          onDrag: (value) {
            mapController!.animateCamera(CameraUpdate.newLatLng(
                LatLng(value.latitude, value.longitude)));
            notifyListeners();
          },
          markerId: MarkerId(
            LatLng(newLat ?? position?.latitude ?? 0.0,
                    newLog ?? position?.longitude ?? 0.0)
                .toString(),
          ),
          position: LatLng(newLat ?? position?.latitude ?? 0.0,
              newLog ?? position?.longitude ?? 0.0),
          infoWindow:
              InfoWindow(title: place?.name, snippet: place?.subLocality),
          icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(devicePixelRatio: 0.8),
              imageAssets.marker) // Icon for Marker
          ));
      notifyListeners();
    }).catchError((e) {
      debugPrint("ee : $e");
    });
  }

// initialized position
  onInit() {
    getCurrentPosition();
    currentAddress = "";
    location.onLocationChanged
        .listen((location_package.LocationData locationData) async {
      if (prevLat == null ||
          prevLon == null ||
          (locationData.latitude! - prevLat!).abs() > 0.0001 ||
          (locationData.longitude! - prevLon!).abs() > 0.0001) {
        prevLat = locationData.latitude;
        prevLon = locationData.longitude;
        getAddressFromLatLng();
      }
    });
    // city = dialogDropDownItems[1]['value'];
  }

  //country change value
  countryChange(newValue) {
    country = newValue;
    notifyListeners();
  }

  //state change value
  stateChange(newValue) {
    state = newValue;
    notifyListeners();
  }
}
