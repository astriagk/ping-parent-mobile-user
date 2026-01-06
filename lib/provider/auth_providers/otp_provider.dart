import 'package:flutter/cupertino.dart';

class OtpProvider extends ChangeNotifier{

TextEditingController pinController = TextEditingController();
final focusNode = FocusNode();
final formKey = GlobalKey<FormState>();
}