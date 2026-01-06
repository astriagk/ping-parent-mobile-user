import 'package:taxify_user_ui/config.dart';

class DriverDetailScreen extends StatelessWidget {
  const DriverDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FindingDriverProvider>(
        builder: (context, findingCtrl, child) {
      return StatefulWrapper(
          onInit: () => findingCtrl.onInit(),
          child: Scaffold(
              appBar: CommonAppBarLayout(title: "Driver Details"),
              body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Image.asset(imageAssets.driverBg,
                                width: MediaQuery.of(context).size.width),
                            Image.asset(imageAssets.profileImg,
                                    width: Sizes.s100,
                                    height: Sizes.s100,
                                    fit: BoxFit.cover)
                                .center()
                                .padding(top: Sizes.s28)
                          ]),
                          DriverDetailsWidgets()
                              .commonTitleLayout(title: "Jonathan Higgins")
                              .center(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                      TextWidgetCommon(
                                          text: "215", fontSize: Sizes.s20),
                                      TextWidgetCommon(
                                          text: "Total Trips",
                                          fontSize: Sizes.s12,
                                          color: appColor(context)
                                              .appTheme
                                              .lightText)
                                    ])
                                    .padding(horizontal: Sizes.s20)
                                    .height(Sizes.s95)
                                    .commonBgBox(context),
                                Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                      TextWidgetCommon(
                                          text: "4.8/5", fontSize: Sizes.s20),
                                      TextWidgetCommon(
                                          text: "Rating",
                                          fontSize: Sizes.s12,
                                          color: appColor(context)
                                              .appTheme
                                              .lightText)
                                    ])
                                    .padding(horizontal: Sizes.s20)
                                    .height(Sizes.s95)
                                    .commonBgBox(context),
                                Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                      TextWidgetCommon(
                                          text: "2", fontSize: Sizes.s20),
                                      TextWidgetCommon(
                                          text: "Total Years",
                                          fontSize: Sizes.s12,
                                          color: appColor(context)
                                              .appTheme
                                              .lightText)
                                    ])
                                    .padding(horizontal: Sizes.s20)
                                    .height(Sizes.s95)
                                    .commonBgBox(context)
                              ]).padding(vertical: Sizes.s20),
                          Image.asset("assets/image/category/mainCar.png"),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextWidgetCommon(
                                          text: "Blue Tesla Diesel Taxi"),
                                      VSpace(Sizes.s20),
                                      Row(children: [
                                        TextWidgetCommon(
                                            text: "CLMV069",
                                            fontSize: Sizes.s18,
                                            fontWeight: FontWeight.w600),
                                        HSpace(Sizes.s6),
                                        SvgPicture.asset(svgAssets.car)
                                      ])
                                    ]),
                                Transform.flip(
                                    flipX: true,
                                    child: Image.asset(imageAssets.luxuryInfo,
                                        height: Sizes.s44))
                              ]).carDetailsExtension(context),
                          DriverDetailsWidgets()
                              .commonTitleLayout(title: "Reviews")
                              .paddingOnly(bottom: Sizes.s8)
                        ]).padding(horizontal: Sizes.s20, vertical: Insets.i20),
                    SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                  imageAssets.profileImg,
                                                  height: Sizes.s24,
                                                  width: Sizes.s24,
                                                  fit: BoxFit.cover),
                                              HSpace(Sizes.s7),
                                              TextWidgetCommon(
                                                  text: "Sledge Hammer"),
                                              HSpace(Sizes.s32),
                                              SvgPicture.asset(svgAssets.star),
                                              HSpace(Sizes.s4),
                                              TextWidgetCommon(
                                                  text: "4.3",
                                                  fontSize: Sizes.s12,
                                                  color: appColor(context)
                                                      .appTheme
                                                      .lightText)
                                            ]),
                                        VSpace(Sizes.s25),
                                        TextWidgetCommon(
                                            text: "“Great service”",
                                            fontSize: Sizes.s12,
                                            color: appColor(context)
                                                .appTheme
                                                .lightText)
                                      ]).reviewExtension(context),
                                  HSpace(Insets.i12),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Image.asset(imageAssets.profileImg,
                                              height: Sizes.s24,
                                              width: Sizes.s24,
                                              fit: BoxFit.cover),
                                          HSpace(Sizes.s7),
                                          TextWidgetCommon(
                                              text: "Sledge Hammer"),
                                          HSpace(Sizes.s32),
                                          SvgPicture.asset(svgAssets.star),
                                          HSpace(Sizes.s4),
                                          TextWidgetCommon(
                                              text: "4.3",
                                              fontSize: Sizes.s12,
                                              color: appColor(context)
                                                  .appTheme
                                                  .lightText)
                                        ]),
                                        VSpace(Sizes.s25),
                                        TextWidgetCommon(
                                            text: "“Great service”",
                                            fontSize: Sizes.s12,
                                            color: appColor(context)
                                                .appTheme
                                                .lightText)
                                      ]).reviewExtension(context),
                                  HSpace(Sizes.s12)
                                ]).padding(bottom: Sizes.s30))
                        .paddingOnly(left: Sizes.s20)
                  ]))));
    });
  }
}
