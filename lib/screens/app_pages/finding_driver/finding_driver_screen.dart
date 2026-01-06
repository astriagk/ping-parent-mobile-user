import 'dart:developer';

import 'package:taxify_user_ui/config.dart';

class FindingDriverScreen extends StatelessWidget {
  const FindingDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FindingDriverProvider>(
        builder: (context, findingCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => findingCtrl.onInit()),
          child: Scaffold(
              appBar: CommonAppBarLayout(title: appFonts.findingDriver),
              body: Column(children: [
                Expanded(
                    child: ListView(padding: EdgeInsets.zero, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    const TimerAndTextLayout(),
                    findingCtrl.min == "00" && findingCtrl.sec == "00"
                        ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: findingCtrl.bidingDriverList
                                    .asMap()
                                    .entries
                                    .map((e) => Column(children: [
                                          SelectRiderWidgets()
                                              .imageCarNameLayout(
                                                  e.value, context)
                                              .inkWell(
                                                  onTap: () => findingCtrl
                                                      .selectedProfileTap(
                                                          e.key, context)),
                                          FindingDriverWidgets()
                                              .driverNameTimeLayout(
                                                  e.value, context)
                                              .inkWell(
                                                  onTap: () => findingCtrl
                                                      .selectedProfileTap(
                                                          e.key, context)),
                                          FindingDriverWidgets()
                                              .ratingUserRatingLayout(
                                                  e.value, context),
                                          SelectRiderWidgets()
                                              .skipAndAcceptButton(context,
                                                  accept: () {
                                            log("message::${e.key}");
                                            log("message::${e.value}");
                                            route.pushNamed(context,
                                                routeName.acceptRideScreen,
                                                arg: {
                                                  "index": e.key,
                                                  "data": e.value
                                                });
                                          })
                                        ]).findingListExtension(context))
                                    .toList())
                            .paddingDirectional(
                                horizontal: Sizes.s20,
                                top: Sizes.s5,
                                bottom: Sizes.s13)
                        : Container(),
                    Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: findingCtrl.findingDriver
                                .map((e) => Column(children: [
                                      FindingDriverWidgets().imageRideType(e),
                                      FindingDriverWidgets()
                                          .dividerLayout(context),
                                      DatePaymentTypeLayout(data: e),
                                      FindingDriverWidgets()
                                          .dividerLayout(context),
                                      FindingLocationLayout(data: e)
                                    ]))
                                .toList())
                        .findingExtension(context)
                  ]),
                  findingCtrl.min == "00" && findingCtrl.sec == "00"
                      ? VSpace(Sizes.s50)
                      : VSpace(MediaQuery.of(context).size.height * 0.42),
                  FindingDriverWidgets().sliderButtonLayout(context)
                ]))
              ])));
    });
  }
}
