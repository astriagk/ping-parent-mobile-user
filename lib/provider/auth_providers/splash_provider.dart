import '../../config.dart';

class SplashProvider extends ChangeNotifier {
  double top = -Sizes.s400;
  // late AnimationController controller;
  bool animation = false;
  // late Animation<double> _animation;
  // page change
  initState(context, splashScreenState) {
/*
    controller = AnimationController(
      upperBound: 0.0,
      vsync: splashScreenState,
      duration: const Duration(seconds: 5), // Adjust duration as needed
    );*/

    // _animation = CurvedAnimation(
    //   parent: controller,
    //   curve: Curves.bounceOut,
    // );
    // Future.delayed(DurationClass.ms150).then((value) {
    //   final splashCtrl = context.read<SplashProvider>();
    //   splashCtrl.initState(context, this);
    //   controller.forward();
    // });

/*    controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        top = Sizes.s70;
        notifyListeners();
        log("bottom: $top");
      });
    });*/
    //
    // Future.delayed(DurationClass.s1).then((value) =>
    //     route.pushNamed(context, routeName.signInScreen));
  }
}
