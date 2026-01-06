import 'dart:async';
import 'package:taxify_user_ui/config.dart';

class FindingDriverProvider extends ChangeNotifier {
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 60);
  bool isCountDown = false;
  String? min, sec;
  List findingDriver = [];
  List bidingDriverList = [];
  int? selectedProfile;

  onInit() {
    findingDriver = appArray.findingDriver;
    bidingDriverList = appArray.bidingDriverList;
    startTimer();
    notifyListeners();
  }

  Future<void> addBidingDriverListWithDelay() async {
    for (var i = 0; i < bidingDriverList.length; i++) {
      Timer(Duration(seconds: i), () {
        bidingDriverList.add(bidingDriverList[i]);
      });
    }
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
    notifyListeners();
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      isCountDown = false;
      countdownTimer!.cancel();
    } else {
      isCountDown = true;
      myDuration = Duration(seconds: seconds);
    }
    notifyListeners();
    String strDigits(int n) => n.toString().padLeft(2, '0');
    min = strDigits(myDuration.inMinutes.remainder(60));
    sec = strDigits(myDuration.inSeconds.remainder(60));
    notifyListeners();
  }

  selectedProfileTap(index, context) {
    selectedProfile = index;
    route.pushNamed(context, routeName.driverDetailScreen);
    notifyListeners();
  }
}
