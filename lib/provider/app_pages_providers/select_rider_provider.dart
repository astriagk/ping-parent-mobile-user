import 'dart:developer';

import 'package:taxify_user_ui/config.dart';

class SelectRiderProvider extends ChangeNotifier {
  bool isInfo = false;
  bool isPayment = false;
  bool isBookNow = false;
  List vehicleType = [];
  TextEditingController price = TextEditingController();
  TextEditingController priceRental = TextEditingController();

  dynamic selectedOption;
  int? selectedIndex;

//list initialization
  onInit() {
    vehicleType = appArray.vehicleType;
    notifyListeners();
  }

  addRider(context) {
    isInfo = false;
    isBookNow = false;
    notifyListeners();
    route.pushNamed(context, routeName.selectRiderScreen);
  }

//vehicle selected change onTap
  onTap(e) {
    selectedIndex = e;
    price.text = vehicleType[selectedIndex!]['amount'];
    notifyListeners();
  }

  //on back button change
  onBackInfo() {
    log('HH');
    isInfo = false;
    isBookNow = false;
    notifyListeners();
  }

  mainBack(context) {
    log('HHMain');
    isInfo = false;
    isBookNow = false;
    isPayment = false;
    selectedIndex = null;
    price.text = "";
    route.pop(context);
    notifyListeners();
  }

//on back button change
  onBackPayment(context) {
    log('HHHHHHH');
    isInfo = false;
    isBookNow = false;

    notifyListeners();
  }

//info tap change
  infoOnTap(index) {
    isInfo = true;
    selectedIndex = index;
    price.text = vehicleType[selectedIndex!]['amount'];
    notifyListeners();
  }

  //select payment method
  selectPayment() {
    isPayment = !isPayment;
    notifyListeners();
  }

  //book now on Tap
  bookNowOnTap() {
    isBookNow = true;
    notifyListeners();
  }
}
