import 'package:flutter/foundation.dart';

class SignUpProvider extends ChangeNotifier {
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
}
