import 'dart:async';
import 'package:flutter/cupertino.dart';

class OtpProvider extends ChangeNotifier {
  TextEditingController pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;

  static const int _resendCooldownSeconds = 120;
  int _secondsRemaining = _resendCooldownSeconds;
  Timer? _timer;

  bool get isVerifying => _isVerifying;
  bool get isResending => _isResending;
  String? get errorMessage => _errorMessage;
  bool get canResend => _secondsRemaining == 0;
  int get secondsRemaining => _secondsRemaining;

  String get timerLabel {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void startResendTimer() {
    _timer?.cancel();
    _secondsRemaining = _resendCooldownSeconds;
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        t.cancel();
      }
    });
  }

  void setIsVerifying(bool value) {
    _isVerifying = value;
    notifyListeners();
  }

  void setIsResending(bool value) {
    _isResending = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
