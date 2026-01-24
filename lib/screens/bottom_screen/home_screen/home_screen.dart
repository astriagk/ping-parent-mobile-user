import 'package:taxify_user_ui/config.dart';

import 'layout/maps_explorer_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChooseRiderProvider, HomeScreenProvider>(
        builder: (context, chooseCtrl, homeCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150).then((value) {
                homeCtrl.init();
                chooseCtrl.onInit();
              }),
          child: Scaffold(
              body: ListView(padding: EdgeInsets.zero, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //card layout
              CardLayout(),
              // top categories layout
              TopCategories(),
              // maps explorer layout
              MapsExplorerLayout(),
              //today's offer layout
              TodayOfferLayout()
            ]).padding(horizontal: Sizes.s20, bottom: Sizes.s100)
          ])));
    });
  }
}
