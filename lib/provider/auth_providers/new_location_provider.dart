import 'dart:developer';

import 'package:skolo/config.dart';

class NewLocationProvider extends ChangeNotifier {
  List selectCategory = [];
  dynamic selectedOption;
  bool isLoading = true;

  // list initialization
  init() {
    isLoading = true;
    notifyListeners();
    selectCategory = appArray.selectCategory;
    selectedOption = selectCategory[0];
    isLoading = false;
    notifyListeners();
  }

//RADIO CHANGE VALUE
  radioValueChange(value, context) {
    log("message==>$value");
    selectedOption = value!;
    notifyListeners();
  }
}
