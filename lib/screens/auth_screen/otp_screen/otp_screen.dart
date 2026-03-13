import 'package:skolo/api/api_client.dart';
import 'package:skolo/api/models/verify_otp_response.dart';
import 'package:skolo/api/services/auth_service.dart';
import 'package:skolo/config.dart';
import 'package:skolo/provider/app_pages_providers/user_provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? phone;
  bool isSignUp = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Clear error message when user arrives at this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OtpProvider>().setErrorMessage(null);
    });
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      phone = args;
    } else if (args is Map<String, dynamic>) {
      phone = args['phone'] as String?;
      isSignUp = args['isSignUp'] as bool? ?? false;
    }
  }

  Future<void> _verifyOtp(String phone, String otp) async {
    final authService = AuthService(ApiClient());
    final otpCtrl = context.read<OtpProvider>();
    try {
      otpCtrl.setIsVerifying(true);
      otpCtrl.setErrorMessage(null);
      final VerifyOtpResponse response = isSignUp
          ? await authService.registerVerifyOtp(phone: phone, otp: otp)
          : await authService.verifyOtp(phone: phone, otp: otp);

      if (!mounted) return;

      otpCtrl.setIsVerifying(false);

      if (response.success) {
        // Authentication data is already saved by AuthService._saveUserSession()

        if (!mounted) return;

        // Fetch user profile and store in global state
        await context.read<UserProvider>().fetchUserProfile();

        // Clear OTP input
        otpCtrl.pinController.text = "";
        otpCtrl.setErrorMessage(null);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidgetCommon(text: response.message)),
        );

        if (isSignUp) {
          route.pushNamed(context, routeName.addLocationScreen);
        } else {
          route.pushNamed(context, routeName.dashBoardLayout);
        }
      } else {
        otpCtrl.setErrorMessage(response.error);
      }
    } catch (e, _) {
      if (!mounted) return;
      otpCtrl.setIsVerifying(false);
      otpCtrl.setErrorMessage('An error occurred while verifying OTP.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpProvider>(builder: (context, otpCtrl, child) {
      return Scaffold(
          backgroundColor: appColor(context).appTheme.bgBox,
          resizeToAvoidBottomInset: false,
          body: PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if (didPop) return;
                otpCtrl.pinController.text = "";
                route.pop(context);
              },
              child: Stack(children: [
                Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // back button and skolo logo layout
                      AuthCommonWidgets().backAndLogo(context, onTap: () {
                        otpCtrl.pinController.text = "";
                        route.pop(context);
                      }),
                      //gif title and subtitle layout
                      AuthCommonWidgets().gifTitleText(
                          context,
                          appFonts.otpVerification,
                          '${appFonts.enterOTPSent} $phone'),
                      TextWidgetCommon(text: appFonts.otp)
                          .padding(bottom: Sizes.s9),
                      // PinPut layout
                      OTPScreenWidgets()
                          .pinPutLayout()
                          .padding(bottom: Sizes.s60),
                      // Error message display
                      if (otpCtrl.errorMessage != null)
                        ErrorMessageWidget(errorMessage: otpCtrl.errorMessage!),
                      // Common button
                      CommonButton(
                          text: appFonts.verify,
                          isLoading: otpCtrl.isVerifying,
                          onTap: () async {
                            final otp = otpCtrl.pinController.text.trim();
                            final phoneNumber = phone?.trim() ?? '';
                            if (phoneNumber.isEmpty || otp.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: TextWidgetCommon(
                                      text: 'Please enter both phone and OTP.'),
                                ),
                              );
                              return;
                            }
                            await _verifyOtp(phoneNumber, otp);
                          }),
                      // Common Rich Text layout
                      AuthCommonWidgets()
                          .commonRichText(context, appFonts.notReceivedYet,
                              appFonts.resendIt)
                          .inkWell(
                              onTap: () => route.pushNamed(
                                  context, routeName.addLocationScreen))
                          .padding(bottom: Sizes.s25, top: Sizes.s15),
                    ]).padding(horizontal: Sizes.s20),
                //common car image layout
                AuthCommonWidgets().commonImage()
              ])
              // .height(MediaQuery.of(context).size.height)
              ));
    });
  }
}
