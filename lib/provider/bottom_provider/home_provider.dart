import 'package:taxify_user_ui/config.dart';

class HomeScreenProvider extends ChangeNotifier {
  List cards = [];
  List categories = [];
  List offer = [];
  List<Contact>? contacted;
  bool permissionDenied = false;

  // list initialization
  init() {
    cards = appArray.carCards;
    categories = appArray.categories;
    offer = appArray.offer;
    notifyListeners();
  }
}
