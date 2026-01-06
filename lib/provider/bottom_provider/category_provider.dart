import 'package:taxify_user_ui/config.dart';

class CategoryProvider extends ChangeNotifier {
  List categoryList = [];
  onInit() {
    categoryList = appArray.categories;
    notifyListeners();
  }
}
