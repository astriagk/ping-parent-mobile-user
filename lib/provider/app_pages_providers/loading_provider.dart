import 'package:taxify_user_ui/config.dart';

class LoadingScreenProvider extends ChangeNotifier {
  AnimationController? controller;
  Animation<double>? animation;

  onInit(context) {
    var riderCtrl = Provider.of<SelectRiderProvider>(context, listen: false);
    Future.delayed(const Duration(seconds: 3)).then((value) {
      riderCtrl.isBookNow = false;
      CancelRideScreen().cancel(context);
    });
    notifyListeners();
  }
}
