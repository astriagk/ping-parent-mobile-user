import 'dart:async';

import 'package:taxify_user_ui/api/api_client.dart';
import 'package:taxify_user_ui/api/models/send_otp_response.dart';
import 'package:taxify_user_ui/api/services/auth_service.dart';
import 'package:taxify_user_ui/config.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear error message when user arrives at this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignUpProvider>().setErrorMessage(null);
    });
  }

  Future<void> _registerSendOtp(String phone) async {
    final signUpProvider = context.read<SignUpProvider>();
    final authService = AuthService(ApiClient());
    try {
      signUpProvider.setIsSending(true);
      signUpProvider.setErrorMessage(null);
      final SendOtpResponse response =
          await authService.registerSendOtp(phone: phone);
      if (!mounted) return;

      signUpProvider.setIsSending(false);

      if (response.success) {
        signUpProvider.setErrorMessage(null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidgetCommon(text: response.message)),
        );
        route.pushNamed(context, routeName.otpScreen,
            arg: {'phone': phone, 'isSignUp': true});
      } else {
        signUpProvider.setErrorMessage(response.error);
      }
    } catch (e, _) {
      if (!mounted) return;
      signUpProvider.setIsSending(false);
      signUpProvider.setErrorMessage('An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signUpProvider, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(svgAssets.logo,
                          height: Sizes.s30, width: Sizes.s70)
                      .center()
                      .padding(top: Sizes.s60, bottom: Sizes.s15),
                  //gif title and subtitle layout
                  AuthCommonWidgets().gifTitleText(context,
                      appFonts.createYourAccount, appFonts.exploreYourLife),
                  TextWidgetCommon(
                      text: appFonts.phoneNumber,
                      style: AppCss.lexendMedium14
                          .textColor(appColor(context).appTheme.darkText)),
                  //country picker layout
                  CountryPickerLayout(controller: phoneController),
                  // Error message display
                  if (signUpProvider.errorMessage != null)
                    ErrorMessageWidget(
                        errorMessage: signUpProvider.errorMessage!),
                  CommonButton(
                      text: appFonts.signup,
                      isLoading: signUpProvider.isSending,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        String phone = phoneController.text.trim();
                        if (phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: TextWidgetCommon(
                                    text: 'Please enter your phone number.')),
                          );
                          return;
                        }
                        await _registerSendOtp(phone);
                      }),
                  //common Rich Text layout
                  AuthCommonWidgets().commonRichText(
                      context, appFonts.alreadyHaveAnAccount, appFonts.signIn,
                      onTap: () {
                    route.pushNamed(context, routeName.signInScreen);
                  }).padding(bottom: Sizes.s25, top: Sizes.s15),
                ]).padding(horizontal: Sizes.s20).authExtension(context),
            //common car image layout
            AuthCommonWidgets().commonImage()
          ]).height(MediaQuery.of(context).size.height));
    });
  }
}
