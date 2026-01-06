import '../../../config.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // back button and taxify logo layout
        AuthCommonWidgets().backAndLogo(context),
        //gif title and subtitle layout
        AuthCommonWidgets().gifTitleText(
            context, appFonts.createYourAccount, appFonts.exploreYourLife),
        //title text and text filed layout
        AuthCommonWidgets().textAndTextField(
            appFonts.userName, appFonts.enterYourName, context),
        //title text and text filed layout
        AuthCommonWidgets()
            .textAndTextField(
                appFonts.mobileNumber, appFonts.enterYourNumber, context)
            .padding(vertical: Sizes.s15),
        //title text and text filed layout
        AuthCommonWidgets().textAndTextField(
            appFonts.email, appFonts.enterYourEmailId, context),
        //title text and text filed layout
        AuthCommonWidgets()
            .textAndTextField(
                appFonts.referralID, appFonts.enterReferralID, context)
            .padding(top: Sizes.s15),
        //common signup button layout
        CommonButton(
                text: appFonts.signup,
                onTap: () => route.pushNamed(context, routeName.otpScreen))
            .padding(top: Sizes.s60, bottom: Sizes.s15),
        //common Rich Text layout
        AuthCommonWidgets().commonRichText(
            context, appFonts.alreadyHaveAnAccount, appFonts.signIn, onTap: () {
          route.pushNamed(context, routeName.signInScreen);
        })
      ])
          .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
          .authExtension(context)
    ]));
  }
}
