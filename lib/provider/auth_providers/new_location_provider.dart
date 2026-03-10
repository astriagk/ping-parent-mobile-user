import 'dart:developer';

import 'package:skolo/config.dart';

class NewLocationProvider extends ChangeNotifier {
  List selectCategory = [];
  dynamic selectedOption;

  // list initialization
  init() {
    selectCategory = appArray.selectCategory;
    selectedOption = selectCategory[0];
    notifyListeners();
  }

//RADIO CHANGE VALUE
  radioValueChange(value, context) {
    log("message==>$value");
    selectedOption = value!;
    notifyListeners();
  }
}
