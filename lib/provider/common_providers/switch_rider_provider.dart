import 'package:taxify_user_ui/screens/app_pages/search_location_screen/layout/switch_rider_sheet.dart';

import '../../config.dart';

class SwitchRiderProvider extends ChangeNotifier {
  List chooseRider = [];

  onInit() {
    chooseRider = appArray.chooseRider;
    notifyListeners();
  }

  onTapEvent(context) {
    return showModalBottomSheet(
        useRootNavigator: false,
        isScrollControlled: true,
        context: context,
        builder: (_) => SwitchRiderSheet());
  }
}
