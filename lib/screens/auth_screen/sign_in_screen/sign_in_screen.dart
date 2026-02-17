import 'package:taxify_user_ui/api/api_client.dart';
import 'package:taxify_user_ui/api/models/send_otp_response.dart';
import 'package:taxify_user_ui/api/services/auth_service.dart';
import 'package:taxify_user_ui/config.dart';
import 'dart:async';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear error message when user arrives at this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignInProvider>().setErrorMessage(null);
    });
  }

  Future<void> _sendOtp(String phone) async {
    final signInProvider = context.read<SignInProvider>();
    final authService = AuthService(ApiClient());
    try {
      signInProvider.setIsSending(true);
      signInProvider.setErrorMessage(null);
      final SendOtpResponse response = await authService.sendOtp(phone: phone);

      if (!mounted) return;

      signInProvider.setIsSending(false);

      if (response.success) {
        signInProvider.setErrorMessage(null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidgetCommon(text: response.message)),
        );
        route.pushNamed(context, routeName.otpScreen, arg: phone);
      } else {
        signInProvider.setErrorMessage(response.error);
      }
    } catch (e, _) {
      if (!mounted) return;
      signInProvider.setIsSending(false);
      signInProvider.setErrorMessage('An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInProvider>(builder: (context, value, child) {
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
                  AuthCommonWidgets().gifTitleText(context, appFonts.letsYouIn,
                      appFonts.heyYouHaveBeenMissed),
                  TextWidgetCommon(
                      text: appFonts.phoneNumber,
                      style: AppCss.lexendMedium14
                          .textColor(appColor(context).appTheme.darkText)),
                  //country picker layout
                  CountryPickerLayout(controller: phoneController),
                  // Error message display
                  if (value.errorMessage != null)
                    ErrorMessageWidget(errorMessage: value.errorMessage!),
                  CommonButton(
                      text: appFonts.getOTP,
                      isLoading: value.isSending,
                      onTap: () async {
                        String phone = phoneController.text.trim();
                        if (phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: TextWidgetCommon(
                                    text: 'Please enter your phone number.')),
                          );
                          return;
                        }
                        await _sendOtp(phone);
                      }),
                  //common Rich Text layout
                  AuthCommonWidgets().commonRichText(
                      context, appFonts.newUser, appFonts.signup, onTap: () {
                    route.pushNamed(context, routeName.signUpScreen);
                  }).padding(bottom: Sizes.s25, top: Sizes.s15),
                  //divider layout
                  // SignInWidgets().dividerLayout(context),
                  //login with google id button
                  // SignInWidgets().googleButton(context),
                ]).padding(horizontal: Sizes.s20).authExtension(context),
            //common car image layout
            AuthCommonWidgets().commonImage()
          ]).height(MediaQuery.of(context).size.height));
    });
  }
}
