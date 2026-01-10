import '../../../config.dart';
import '../../../api/services/auth_service.dart';
import '../../../api/api_client.dart';
import '../../../api/models/verify_otp_response.dart';
import '../../../helper/auth_helper.dart';

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
      final VerifyOtpResponse response = isSignUp
          ? await authService.registerVerifyOtp(phone: phone, otp: otp)
          : await authService.verifyOtp(phone: phone, otp: otp);

      if (!mounted) return;

      // Clear OTP input
      final otpProvider = Provider.of<OtpProvider>(context, listen: false);

      if (response.success) {
        // Save authentication data
        if (response.token != null && response.user != null) {
          await AuthHelper.saveAuthData(
            token: response.token!,
            user: response.user!,
          );
        }

        if (!mounted) return;

        // Clear OTP input
        otpCtrl.pinController.text = "";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidgetCommon(text: response.message)),
        );

        if (isSignUp) {
          route.pushNamed(context, routeName.addLocationScreen);
        } else {
          route.pushNamed(context, routeName.dashBoardLayout);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: TextWidgetCommon(text: response.error)));
      }
    } catch (e, _) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: TextWidgetCommon(
                text: 'An error occurred while verifying OTP.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpProvider>(builder: (context, otpCtrl, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if (didPop) return;
                otpCtrl.pinController.text = "";
                route.pop(context);
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          // back button and taxify_user_ui logo layout
                          AuthCommonWidgets().backAndLogo(context, onTap: () {
                            otpCtrl.pinController.text = "";
                            route.pop(context);
                          }),
                          //gif title and subtitle layout
                          AuthCommonWidgets().gifTitleText(context,
                              appFonts.otpVerification, appFonts.enterOTPSent),
                          TextWidgetCommon(text: appFonts.otp)
                              .padding(bottom: Sizes.s9),
                          // PinPut layout
                          OTPScreenWidgets().pinPutLayout(),
                          // Common button
                          CommonButton(
                              text: appFonts.verify,
                              onTap: () async {
                                final otp = otpCtrl.pinController.text.trim();
                                final phoneNumber = phone?.trim() ?? '';
                                if (phoneNumber.isEmpty || otp.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: TextWidgetCommon(
                                          text:
                                              'Please enter both phone and OTP.'),
                                    ),
                                  );
                                  return;
                                }
                                await _verifyOtp(phoneNumber, otp);
                              }).padding(top: Sizes.s60, bottom: Sizes.s15),
                          // Common Rich Text layout
                          AuthCommonWidgets()
                              .commonRichText(context, appFonts.notReceivedYet,
                                  appFonts.resendIt)
                              .inkWell(
                                  onTap: () => route.pushNamed(
                                      context, routeName.addLocationScreen))
                        ])
                        .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                        .decorated(
                            color: appColor(context).appTheme.bgBox,
                            bLRadius: Sizes.s20,
                            bRRadius: Sizes.s20),
                    //common car image layout
                    AuthCommonWidgets().commonImage()
                  ])));
    });
  }
}
