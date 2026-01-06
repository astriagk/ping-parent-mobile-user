import 'package:flutter/cupertino.dart';

class CompletedRideProvider extends ChangeNotifier {
  dynamic data;
  dynamic index;
  dynamic id;
  dynamic carName;
  dynamic driverProfile;
  dynamic driverName;
  dynamic rating;
  dynamic userRatingNumber;
  dynamic status;
  dynamic date;
  dynamic time;
  dynamic code;
  dynamic value;
  double? _ratingValue = 3.0; // default rating value
  double? get ratingValue => _ratingValue;

  TextEditingController commentController = TextEditingController();

  int? selectedTip;
  final List<String> tipOptions = ['\$5', '\$10', '\$15', 'Custom'];

  void setRatingValue(double rating) {
    _ratingValue = rating;
    notifyListeners();
  }

  getArgument(context) {
    data = ModalRoute.of(context)!.settings.arguments;
    index = data["index"];
    value = data["value"];
    id = value['id'];
    carName = value['fullCarName'];
    driverProfile = value['driverProfile'];
    driverName = value['driverName'];
    rating = value['rating'];
    userRatingNumber = value['userRatingNumber'];
    status = value['status'];
    date = value['date'];
    time = value['time'];
    code = value['code'];
    notifyListeners();
  }
}
