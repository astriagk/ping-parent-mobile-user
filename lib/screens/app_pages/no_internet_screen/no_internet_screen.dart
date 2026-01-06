import '../../../config.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Image.asset(imageAssets.noInternet)
          .marginSymmetric(horizontal: Insets.i60),
      VSpace(Insets.i67),
      Text("No Internet Connection",
          style: AppCss.lexendLight14.textColor(appTheme.primary)),
      VSpace(Insets.i13),
      Text("There is no call done yet. Click on Below Button to start call",
          style: AppCss.lexendLight14
              .textColor(appTheme.hintTextClr)
              .textHeight(1.3),
          textAlign: TextAlign.center),
      VSpace(Insets.i60),
      CommonButton(
          text: "Try again",
          onTap: () =>
              route.pushReplacementNamed(context, routeName.chatScreen)),
      VSpace(Insets.i80)
    ]).padding(horizontal: Insets.i30));
  }
}
