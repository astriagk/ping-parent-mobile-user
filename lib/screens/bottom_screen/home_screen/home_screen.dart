import 'package:taxify_user_ui/config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ChooseRiderProvider, HomeScreenProvider,
            TripTrackingProvider>(
        builder: (context, chooseCtrl, homeCtrl, tripCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150).then((value) {
                homeCtrl.init();
                chooseCtrl.onInit();
                tripCtrl.init();
              }),
          child: Scaffold(
              body: ListView(padding: EdgeInsets.zero, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //card layout
              CardLayout(),
              // top categories layout
              TopCategories(),
              //today's offer layout
              TodayOfferLayout()
            ]).padding(horizontal: Sizes.s20, bottom: Sizes.s100)
          ])));
    });
  }
}
