import 'package:taxify_user_ui/config.dart';

class MyRideScreenProvider extends ChangeNotifier {
  List rideStatus = [];
  List rideStatusList = [];

  int? selectStatus = 0;
  List filteredRideStatusList = [];

  selectedOptionIndex(int index) {
    selectStatus = index;
    filterRidesByStatus(rideStatus[selectStatus!]);
    notifyListeners();
  }

  void filterRidesByStatus(String status) {
    if (status == "Active Ride") {
      filteredRideStatusList =
          rideStatusList.where((ride) => ride["status"] == "Active").toList();
    } else if (status == "Pending Ride") {
      filteredRideStatusList =
          rideStatusList.where((ride) => ride["status"] == "Pending").toList();
    } else if (status == "Complete Ride") {
      filteredRideStatusList =
          rideStatusList.where((ride) => ride["status"] == "Complete").toList();
    } else if (status == "Cancel Ride") {
      filteredRideStatusList = rideStatusList
          .where((ride) => ride["status"] == "Cancelled")
          .toList();
    } else {
      filteredRideStatusList = [];
    }
  }

  onInit() {
    rideStatus = appArray.rideStatus;
    rideStatusList = appArray.rideStatusList;
    filterRidesByStatus(rideStatus[selectStatus!]);

    notifyListeners();
  }

  // //set select option index
  // selectedOption(int index) {
  //   selectStatus = index;
  //   notifyListeners();
  // }
}
