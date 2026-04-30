import 'package:skolo/api/api_client.dart';
import 'package:skolo/api/models/send_otp_response.dart';
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
  String? countryCode;
  bool isSignUp = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final otpCtrl = context.read<OtpProvider>();
      otpCtrl.setErrorMessage(null);
      otpCtrl.startResendTimer();
    });
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      phone = args;
    } else if (args is Map<String, dynamic>) {
      phone = args['phone'] as String?;
      isSignUp = args['isSignUp'] as bool? ?? false;
      countryCode = args['countryCode'] as String?;
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
        if (!mounted) return;

        await context.read<UserProvider>().fetchUserProfile();

        otpCtrl.pinController.text = "";
        otpCtrl.setErrorMessage(null);

        if (!mounted) return;
        AppSnackBar.success(context, response.message ?? 'OTP verified successfully');

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

  Future<void> _resendOtp() async {
    final otpCtrl = context.read<OtpProvider>();
    if (!otpCtrl.canResend) {
      AppSnackBar.warning(
          context, 'Please wait ${otpCtrl.timerLabel} before resending.');
      return;
    }
    final authService = AuthService(ApiClient());
    try {
      otpCtrl.setIsResending(true);
      otpCtrl.setErrorMessage(null);
      final SendOtpResponse response = isSignUp
          ? await authService.resendRegisterOtp(
              phone: phone ?? '', countryCode: countryCode)
          : await authService.resendOtp(
              phone: phone ?? '', countryCode: countryCode);

      if (!mounted) return;
      otpCtrl.setIsResending(false);

      if (response.success) {
        AppSnackBar.success(
            context, response.message ?? 'OTP resent successfully');
        otpCtrl.startResendTimer();
      } else {
        otpCtrl.setErrorMessage(response.error);
      }
    } catch (e) {
      if (!mounted) return;
      otpCtrl.setIsResending(false);
      otpCtrl.setErrorMessage('An error occurred. Please try again.');
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
                      AuthCommonWidgets().backAndLogo(context, onTap: () {
                        otpCtrl.pinController.text = "";
                        route.pop(context);
                      }),
                      AuthCommonWidgets().gifTitleText(
                          context,
                          appFonts.otpVerification,
                          '${appFonts.enterOTPSent} $phone'),
                      TextWidgetCommon(text: appFonts.otp)
                          .padding(bottom: Sizes.s9),
                      OTPScreenWidgets()
                          .pinPutLayout()
                          .padding(bottom: Sizes.s60),
                      if (otpCtrl.errorMessage != null)
                        ErrorMessageWidget(errorMessage: otpCtrl.errorMessage!),
                      CommonButton(
                          text: appFonts.verify,
                          isLoading: otpCtrl.isVerifying,
                          onTap: () async {
                            final otp = otpCtrl.pinController.text.trim();
                            final phoneNumber = phone?.trim() ?? '';
                            if (phoneNumber.isEmpty || otp.isEmpty) {
                              AppSnackBar.warning(context,
                                  'Please enter both phone and OTP.');
                              return;
                            }
                            await _verifyOtp(phoneNumber, otp);
                          }),
                      _resendRow(context, otpCtrl),
                    ]).padding(horizontal: Sizes.s20),
                AuthCommonWidgets().commonImage()
              ])));
    });
  }

  Widget _resendRow(BuildContext context, OtpProvider otpCtrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidgetCommon(
          text: appFonts.notReceivedYet,
          style: AppCss.lexendRegular14
              .textColor(appColor(context).appTheme.lightText),
        ),
        if (!otpCtrl.canResend)
          TextWidgetCommon(
            text: ' ${otpCtrl.timerLabel}',
            style: AppCss.lexendMedium14
                .textColor(appColor(context).appTheme.primary),
          )
        else
          GestureDetector(
            onTap: otpCtrl.isResending ? null : _resendOtp,
            child: otpCtrl.isResending
                ? SizedBox(
                    height: Sizes.s16,
                    width: Sizes.s16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: appColor(context).appTheme.primary,
                    ),
                  ).padding(left: Sizes.s8)
                : TextWidgetCommon(
                    text: appFonts.resendIt,
                    style: AppCss.lexendMedium14
                        .textColor(appColor(context).appTheme.primary),
                  ),
          ),
      ],
    ).padding(bottom: Sizes.s25, top: Sizes.s15);
  }
}
