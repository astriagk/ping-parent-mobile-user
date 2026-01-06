import '../../../config.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
                                  onTap: () => route.pushNamed(
                                      context, routeName.addLocationScreen))
                              .padding(top: Sizes.s60, bottom: Sizes.s15),
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
