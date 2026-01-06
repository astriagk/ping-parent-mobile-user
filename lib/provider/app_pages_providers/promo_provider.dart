import '../../config.dart';

class PromoProvider extends ChangeNotifier{

  List promoList = [];
  //List initialization
  init(){
    promoList = appArray.promoList;
    notifyListeners();
  }

}