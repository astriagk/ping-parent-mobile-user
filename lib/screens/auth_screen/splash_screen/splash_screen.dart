import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:skolo/config.dart';
import 'package:skolo/screens/auth_screen/splash_screen/layout/custom_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;

  void handleTap() {
    setState(() {
      if (currentPage < 2) {
        currentPage++;
      } else {
        Navigator.pushNamed(context, routeName.signInScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splashCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => splashCtrl.initState(context, this)),
          child: Scaffold(
              backgroundColor: appColor(context).appTheme.bgBox,
              body: Stack(children: [
                // Logo centered in the upper area
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: Insets.i256 + Insets.i15,
                    child: Center(
                        child: Image.asset(imageAssets.mainLogo,
                            width: Sizes.s200))),
                // Bottom onboarding card
                Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomPaint(
                        size: Size(
                            335, (256 * 0.764179104477612).toDouble()),
                        painter: RPSCustomPainter(),
                        child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              Column(children: [
                                Text(
                                    appArray.onboardingData[currentPage]
                                        ['title']!,
                                    style: AppCss.lexendBold20
                                        .textColor(appTheme.primary)),
                                SizedBox(height: Insets.i25),
                                Text(
                                    appArray.onboardingData[currentPage]
                                        ['description']!,
                                    style: AppCss.lexendRegular14
                                        .textColor(appTheme.onBoardTxtClr)
                                        .textHeight(1.5),
                                    textAlign: TextAlign.center)
                              ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SmoothPageIndicator(
                                        controller: PageController(
                                            initialPage: currentPage),
                                        count: 3,
                                        axisDirection: Axis.horizontal,
                                        effect: ExpandingDotsEffect(
                                            spacing: 3,
                                            expansionFactor: 4,
                                            activeDotColor:
                                                appTheme.primary,
                                            dotHeight: 5,
                                            dotColor:
                                                appTheme.onBoardDotClr,
                                            dotWidth: 6)),
                                    CommonIconButton(
                                        iconColor: ColorFilter.mode(
                                            appTheme.white,
                                            BlendMode.srcIn),
                                        bgColor: appTheme.primary,
                                        onTap: handleTap,
                                        icon: svgAssets.arrow)
                                  ])
                            ])
                            .padding(
                                bottom: Insets.i25,
                                top: Insets.i53,
                                horizontal: Insets.i25)
                            .height(Insets.i256)
                            .width(Insets.i335)))
                    .marginOnly(bottom: Insets.i15),
              ])));
    });
  }
}
