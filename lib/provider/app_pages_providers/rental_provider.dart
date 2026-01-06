import 'package:taxify_user_ui/config.dart';

class RentalProvider extends ChangeNotifier {
  List packageList = [];
  int? selectedIndex;
  int? hourSelectedIndex;
  List vehicleType = [];
  bool isPayment = false;
  TextEditingController price = TextEditingController();

//list initialisation
  onInit() {
    packageList = appArray.packageList;
    vehicleType = appArray.vehicleType;
    notifyListeners();
  }

//vehicle onTap
  onTap(e) {
    selectedIndex = e;
    price.text = vehicleType[selectedIndex!]['amount'];
    notifyListeners();
  }

  //select payment method
  selectPayment() {
    isPayment = !isPayment;
    notifyListeners();
  }

  //packageList OnTap
  packageListOnTap(e) {
    hourSelectedIndex = e;
    notifyListeners();
  }

  //info tap change
  infoOnTap(index, context) {
    selectedIndex = index;
    price.text = vehicleType[selectedIndex!]['amount'];
    route.pushNamed(context, routeName.rentalInfoScreen);
    notifyListeners();
  }
}
