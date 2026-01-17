import 'package:taxify_user_ui/screens/app_pages/subscription_management/subscription_management_screen.dart';

import '../../config.dart';

class DashBoardProvider extends ChangeNotifier {
  int currentTab = 0;
  bool isImage = true;
  List bottomNavigationBarList = [];
  ScrollController? scrollViewController;

  //tab screens list
  final List<Widget> screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const SubscriptionManagementScreen(),
    const SettingsScreen(),
  ];
  // Initialize list
  onInit() {
    bottomNavigationBarList = appArray.bottomNavigationBarList;
    scrollViewController = ScrollController(initialScrollOffset: 0.0);
    scrollViewController!.addListener(changeColor);
    notifyListeners();
  }

//CHANGE COLOUR
  void changeColor() {
    if ((scrollViewController!.offset == 0)) {
      isImage = true;
    } else if ((scrollViewController!.offset <= 80)) {
      isImage = true;
    } else if ((scrollViewController!.offset <= 100)) {
      isImage = false;
    }
    notifyListeners();
  }

//navigation tab change
  tabChange(int index) {
    currentTab = index;
    notifyListeners();
  }
}
