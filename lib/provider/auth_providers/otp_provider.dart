import 'package:flutter/cupertino.dart';

class OtpProvider extends ChangeNotifier {
  TextEditingController pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool _isVerifying = false;
  String? _errorMessage;

  bool get isVerifying => _isVerifying;
  String? get errorMessage => _errorMessage;

  void setIsVerifying(bool value) {
    _isVerifying = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
