import 'package:taxify_user_ui/config.dart';

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
                    return GestureDetector(
                        onTap: () {
                          if (e["status"] != "Active") {
                            route.pushNamed(
                                context, routeName.completedRideScreen,
                                arg: {'index': index, 'value': entries.value});
                          }
                        },
                        child: Column(children: [
                          Row(children: [
                            SizedBox(
                                height: Sizes.s50,
                                width: Sizes.s50,
                                child: SvgPicture.asset(e['image'])
                                    .padding(horizontal: Sizes.s4)
                                    .decorated(
                                        color: appColor(context).appTheme.bgBox,
                                        allRadius: Sizes.s7)),
                            HSpace(Sizes.s10),
                            Expanded(
                                child: Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidgetCommon(
                                        text: "ID : ${e['id']}",
                                        fontSize: Sizes.s13,
                                        fontWeight: FontWeight.w400),
                                    TextWidgetCommon(
                                        text: "• ${e['status']}",
                                        color: e["status"] == "Active"
                                            ? appColor(context)
                                                .appTheme
                                                .activeColor
                                            : e["status"] == "Pending"
                                                ? appColor(context)
                                                    .appTheme
                                                    .yellowIcon
                                                : e["status"] == "Complete"
                                                    ? appColor(context)
                                                        .appTheme
                                                        .success
                                                    : appColor(context)
                                                        .appTheme
                                                        .alertZone,
                                        fontSize: Sizes.s12,
                                        fontWeight: FontWeight.w500)
                                  ]),
                              VSpace(Sizes.s7),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidgetCommon(
                                        text:
                                            '${getSymbol(context)}${(currency(context).currencyVal * double.parse(e['price'])).toStringAsFixed(2)}',
                                        color:
                                            appColor(context).appTheme.success,
                                        fontSize: Sizes.s13,
                                        fontWeight: FontWeight.w500),
                                    TextWidgetCommon(
                                        text: "${e['date']} at ${e['time']}",
                                        color: appColor(context)
                                            .appTheme
                                            .lightText,
                                        fontSize: Sizes.s12,
                                        fontWeight: FontWeight.w300)
                                  ])
                            ]))
                          ]),
                          DottedLine(
                                  dashColor: appColor(context).appTheme.stroke)
                              .padding(vertical: Sizes.s15),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        TextWidgetCommon(
                                            text: '${e['driverName']}',
                                            fontSize: Sizes.s12,
                                            fontWeight: FontWeight.w400),
                                        HSpace(Sizes.s6),
                                        SvgPicture.asset(svgAssets.star),
                                        HSpace(Sizes.s4),
                                        TextWidgetCommon(
                                            text: '${e['rating']}',
                                            fontSize: Sizes.s12,
                                            fontWeight: FontWeight.w400),
                                        TextWidgetCommon(
                                            text: e['userRatingNumber'],
                                            color: appColor(context)
                                                .appTheme
                                                .lightText,
                                            fontSize: Sizes.s12,
                                            fontWeight: FontWeight.w400),
                                      ]),
                                      VSpace(Sizes.s4),
                                      TextWidgetCommon(
                                          text: '${e['carName']}',
                                          color: appColor(context)
                                              .appTheme
                                              .lightText)
                                    ]),
                                Container(
                                    height: Insets.i32,
                                    width: Insets.i32,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                imageAssets.profileImg))))
                              ]),
                          VSpace(Sizes.s15),
                          FindingLocationLayout(
                                  data: e,
                                  loc1Color:
                                      appColor(context).appTheme.darkText)
                              .padding(
                                  horizontal: Sizes.s10, vertical: Sizes.s10)
                              .decorated(
                                  color: appColor(context).appTheme.bgBox,
                                  allRadius: Sizes.s8)
                        ]).myRideListExtension(context));
                  })
                ]))
          ])));
    });
  }
}
