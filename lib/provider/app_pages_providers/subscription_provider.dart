import 'package:taxify_user_ui/config.dart';

class SubscriptionProvider extends ChangeNotifier {
  List subscriptionStatus = [];
  List subscriptionList = [];

  int? selectStatus = 0;
  List filteredSubscriptionList = [];

  selectedOptionIndex(int index) {
    selectStatus = index;
    filterSubscriptionsByStatus(subscriptionStatus[selectStatus!]);
    notifyListeners();
  }

  void filterSubscriptionsByStatus(String status) {
    if (status == "Active") {
      filteredSubscriptionList = subscriptionList
          .where((subscription) => subscription["status"] == "Active")
          .toList();
    } else if (status == "Pending") {
      filteredSubscriptionList = subscriptionList
          .where((subscription) => subscription["status"] == "Pending")
          .toList();
    } else if (status == "Expired") {
      filteredSubscriptionList = subscriptionList
          .where((subscription) => subscription["status"] == "Expired")
          .toList();
    } else if (status == "Cancelled") {
      filteredSubscriptionList = subscriptionList
          .where((subscription) => subscription["status"] == "Cancelled")
          .toList();
    } else {
      filteredSubscriptionList = [];
    }
  }

  onInit() {
    subscriptionStatus = appArray.subscriptionStatus;
    subscriptionList = appArray.subscriptionList;
    filterSubscriptionsByStatus(subscriptionStatus[selectStatus!]);

    notifyListeners();
  }
}
