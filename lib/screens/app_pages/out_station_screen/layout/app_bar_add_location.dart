import '../../../../config.dart';

class AppBarAndAddLocationLayout extends StatelessWidget {
  const AppBarAndAddLocationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //appBar layout
      OutStationWidgets().appBarLayout(context),
      VSpace(Sizes.s20),
      //add new Location TextField layout
      OutStationWidgets().addLocationLayout(context)
    ])
        .padding(horizontal: Sizes.s20, top: Sizes.s50, bottom: Sizes.s20)
        .authExtension(context);
  }
}
