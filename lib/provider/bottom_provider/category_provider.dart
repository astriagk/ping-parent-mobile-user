import 'package:skolo/config.dart';

class CategoryProvider extends ChangeNotifier {
  List categoryList = [];
  onInit() {
    categoryList = appArray.categories;
    notifyListeners();
  }
}
