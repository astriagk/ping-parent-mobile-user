import 'package:flutter/cupertino.dart';

class AppSettingProvider extends ChangeNotifier {
  bool isNotification = false;
  bool isNotificationSwitch = true;

  //paymentNotification switch
  notificationSwitch() {
    isNotificationSwitch = !isNotificationSwitch;
    notifyListeners();
  }

  init() {}
}
