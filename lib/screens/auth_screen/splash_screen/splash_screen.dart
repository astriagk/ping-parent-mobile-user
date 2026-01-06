import 'dart:async';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/screens/auth_screen/splash_screen/layout/custom_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rowController;
  late Animation<Offset> _rowAnimation;
  late AnimationController _carController;
  late Animation<double> _carAnimation;
  late AnimationController _fadeDotLineController;
  late AnimationController _fadeRoadController;
  late Animation<double> _fadeDotLineAnimation;
  late Animation<double> _fadeRoadAnimation;
  double opacityLevel = 0.0;
  bool showBikes = false;

  @override
  void initState() {
    super.initState();

    _rowController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _rowAnimation = Tween<Offset>(
            begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0))
        .animate(
            CurvedAnimation(parent: _rowController, curve: Curves.easeInOut));

    _carController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    _carAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: -Sizes.s400, end: Sizes.s100)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: Sizes.s100, end: 130)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50)
    ]).animate(_carController);

    _fadeDotLineController = AnimationController(
        duration: const Duration(microseconds: 1500), vsync: this);

    _fadeDotLineAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _fadeDotLineController, curve: Curves.easeOut));

    _fadeRoadController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    _fadeRoadAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _fadeRoadController, curve: Curves.easeOut));

    // Start the row animation first, then the car animation
    _rowController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1500)).then((value) {
        _carController.forward().then((_) {
          _fadeDotLineController.forward().then((_) {
            _fadeRoadController.forward().then((value) => Future.delayed(
                    DurationClass
                        .s1) /*.then((value) =>
                    route.pushNamed(context, routeName.signInScreen))*/
                .then(//container in the bottom for the onboarding
                    (value) => Future.delayed(Duration(milliseconds: 1000), () {
                          setState(() {
                            showContainer = true;
                          });
                        }))
                .then(
                    (value) => Future.delayed(Duration(milliseconds: 500), () {
                          setState(() {
                            showBikes = true;
                          });
                        })));
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _rowController.dispose();
    _carController.dispose();
    _fadeDotLineController.dispose();
    _fadeRoadController.dispose();
    super.dispose();
  }

  int currentPage = 0; // To track the current page
  void handleTap() {
    setState(() {
      if (currentPage < 2) {
        // Increment page indicator on first and second taps
        currentPage++;
      } else {
        // Navigate to SignInScreen on the third tap
        Navigator.pushNamed(context, routeName.signInScreen);
      }
    });
  }

  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  bool showContainer = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splashCtrl, child) {
      // Ensure splashCtrl is not null before using it
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => splashCtrl.initState(context, this)),
          child: Scaffold(
              backgroundColor: const Color(0xFFF1F1F1),
              body: Stack(children: [
                SlideTransition(
                    position: _rowAnimation,
                    child: AnimatedBuilder(
                        animation: _fadeDotLineAnimation,
                        builder: (context, child) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Opacity(
                                    opacity: _fadeDotLineAnimation.value,
                                    child:
                                        Image.asset(imageAssets.splashDotLine)),
                                AnimatedBuilder(
                                    animation: _fadeRoadAnimation,
                                    builder: (context, child) {
                                      return Opacity(
                                          opacity: _fadeRoadAnimation.value,
                                          child: Image.asset(
                                                  imageAssets.splashRoad,
                                                  fit: BoxFit.fill)
                                              .center());
                                    }),
                                Opacity(
                                    opacity: _fadeDotLineAnimation.value,
                                    child:
                                        Image.asset(imageAssets.splashDotLine))
                              ]).paddingDirectional(
                              horizontal: Sizes.s20, top: Sizes.s230);
                        })),
                AnimatedContainer(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeOut,
                        transform: Matrix4.translationValues(
                            0.0, showContainer ? 0 : 350, 0.0),
                        child: Align(
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
                                                .textColor(
                                                    appTheme.onBoardTxtClr)
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
                                    .width(Insets.i335))))
                    .marginOnly(bottom: Insets.i15),
                Image.asset(imageAssets.splashRound),
                showBikes
                    ? Positioned(
                        top: 55,
                        height: 160,
                        left: -40,
                        child: Transform.rotate(
                            angle: 0.8,
                            child: Image.asset(imageAssets.splashBike)))
                    : Container(),
                showBikes
                    ? Positioned(
                        top: 55,
                        right: -40,
                        height: 160,
                        child: Transform.rotate(
                            angle: -0.8,
                            child: Image.asset(imageAssets.splashBike)))
                    : Container(),
                AnimatedBuilder(
                    animation: _carAnimation,
                    builder: (context, child) {
                      return Positioned(
                          top: _carAnimation.value,
                          left: 0,
                          right: 0,
                          child: Align(
                              alignment: Alignment.topCenter,
                              // Align the car image to the center
                              child: Image.asset(imageAssets.splashCar,
                                  fit: BoxFit.cover)));
                    })
              ])));
    });
  }
}
