import 'dart:developer';

import 'package:flutter/cupertino.dart';

class BankDetailsProvider extends ChangeNotifier {
  TextEditingController bankName = TextEditingController();
  TextEditingController holderName = TextEditingController();
  TextEditingController accountNo = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController swiftCode = TextEditingController();
  dynamic branch;
  //select card number dropDown layout
  List branchDropDownItems = [
    {'value': 1, 'label': 'katargam'},
    {'value': 2, 'label': 'varachha'},
    {'value': 3, 'label': 'singanpor'},
  ];
//controller initialization
  init() {
    bankName.text = "DBS Bank";
    holderName.text = "Zain Dorwart";
    accountNo.text = "1256 2635 8956";
    ifscCode.text = "DBSS0IN0831";
    swiftCode.text = "DBSSINBB";
    branch = branchDropDownItems[0]['value'];
    notifyListeners();
  }

  //state change value
  branchChange(newValue) {
    branch = newValue;
    notifyListeners();
  }
}
