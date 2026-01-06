import '../../config.dart';

class SaveLocationProvider with ChangeNotifier {
  List saveLocationList = [];

  // List initialization
  void init() {
    saveLocationList = appArray.saveLocation;
    notifyListeners();
  }

  // Remove location method
  void removeLocation(location, context) {
    route.pop(context);
    saveLocationList.remove(location);
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return CommonDialog(
    //           buttonText: "Go, back",
    //           onTap: () => route.pop(context),
    //           title: "Successful delete your address",
    //           image: imageAssets.bookingSuccess,
    //         );
    //       });
    notifyListeners();
  }
}
