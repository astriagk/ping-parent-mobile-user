import 'package:taxify_user_ui/config.dart';
import '../../../widgets/ride_card/ride_card.dart';
import '../../../widgets/ride_card/layout/ride_data_model.dart';

class MyRidesScreen extends StatelessWidget {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyRideScreenProvider>(
        builder: (context, myRideCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => myRideCtrl.onInit()),
          child: Scaffold(
              body: Column(children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  HSpace(Sizes.s20),
                  ...myRideCtrl.rideStatus.asMap().entries.map((e) =>
                      TextWidgetCommon(
                              text: e.value,
                              color: myRideCtrl.selectStatus == e.key
                                  ? appColor(context).appTheme.white
                                  : appColor(context).appTheme.darkText)
                          .padding(vertical: Sizes.s11, horizontal: Sizes.s12)
                          .decorated(
                              color: myRideCtrl.selectStatus == e.key
                                  ? appColor(context).appTheme.primary
                                  : appColor(context).appTheme.white,
                              allRadius: Sizes.s6,
                              sideColor: myRideCtrl.selectStatus == e.key
                                  ? appColor(context).appTheme.primary
                                  : appColor(context).appTheme.bgBox,
                              boxShadow: [
                                BoxShadow(
                                    color: appColor(context)
                                        .appTheme
                                        .primary
                                        .withValues(alpha: 0.04),
                                    blurRadius: 12,
                                    spreadRadius: 4)
                              ])
                          .inkWell(
                              onTap: () =>
                                  myRideCtrl.selectedOptionIndex(e.key))
                          .padding(vertical: Sizes.s20, right: Sizes.s12)),
                ])),
            Expanded(
                child: ListView(
                    padding: EdgeInsets.only(bottom: Sizes.s80),
                    children: [
                  ...myRideCtrl.filteredRideStatusList
                      .asMap()
                      .entries
                      .map((entries) {
                    var e = entries.value;
                    var index = entries.key;
                    return RideCard(
                      rideData: RideDataModel.fromMap(e),
                      index: index,
                      onTap: () {
                        if (e["status"] != "Active") {
                          route.pushNamed(
                              context, routeName.completedRideScreen,
                              arg: {'index': index, 'value': entries.value});
                        }
                      },
                    );
                  })
                ]))
          ])));
    });
  }
}
