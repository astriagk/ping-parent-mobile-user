import 'package:taxify_user_ui/config.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
                  const CountryPickerLayout(),
                  CommonButton(
                      text: appFonts.getOTP,
                      onTap: () =>
                          route.pushNamed(context, routeName.otpScreen)),
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
