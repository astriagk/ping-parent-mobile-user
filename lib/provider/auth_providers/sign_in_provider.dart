import 'package:skolo/config.dart';

class SignInProvider extends ChangeNotifier {
  String countryCode = "";
  TextEditingController signInController = TextEditingController();
  bool _isSending = false;
  String? _errorMessage;

  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  void setIsSending(bool value) {
    _isSending = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  //change country code
  onCountryCode(String? dialCode) {
    debugPrint("dial code==>$dialCode");
    notifyListeners();
  }
}
