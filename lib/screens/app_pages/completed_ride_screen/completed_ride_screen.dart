import '../../../config.dart';
import '../../../widgets/location/route_location_display.dart';

class CompletedRideScreen extends StatelessWidget {
  const CompletedRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CompletedRideProvider>(builder: (context, rideCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => rideCtrl.getArgument(context)),
          child: Scaffold(
              body: Stack(children: [
            ListView(children: [
              Image.asset(imageAssets.rideMap)
                  .paddingDirectional(top: Sizes.s50, bottom: Sizes.s20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Image.asset("${rideCtrl.driverProfile}",
                      height: Sizes.s46, width: Sizes.s46),
                  HSpace(Sizes.s8),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidgetCommon(text: rideCtrl.driverName),
                              TextWidgetCommon(
                                  text: "•  ${rideCtrl.status}",
                                  color: rideCtrl.status == "Active"
                                      ? appColor(context).appTheme.activeColor
                                      : rideCtrl.status == "Pending"
                                          ? appColor(context)
                                              .appTheme
                                              .yellowIcon
                                          : rideCtrl.status == "Complete"
                                              ? appColor(context)
                                                  .appTheme
                                                  .success
                                              : appColor(context)
                                                  .appTheme
                                                  .alertZone)
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                SvgPicture.asset(svgAssets.star),
                                HSpace(Sizes.s6),
                                TextWidgetCommon(text: rideCtrl.rating),
                                TextWidgetCommon(
                                    text: rideCtrl.userRatingNumber,
                                    color: appColor(context).appTheme.lightText)
                              ])
                            ])
                      ]))
                ]),
                if (rideCtrl.status != 'Cancelled')
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidgetCommon(
                                text: "Rate Us",
                                fontSize: Sizes.s14,
                                fontWeight: FontWeight.w500)
                            .padding(top: Sizes.s20, bottom: Sizes.s8),
                        IntrinsicHeight(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  unratedColor: appTheme.stroke,
                                  itemSize: 26,
                                  itemPadding:
                                      EdgeInsets.only(right: Insets.i16),
                                  itemBuilder: (context, _) =>
                                      SvgPicture.asset(svgAssets.star1),
                                  onRatingUpdate: (rating) {
                                    rideCtrl.setRatingValue(rating);
                                  }),
                              VerticalDivider(
                                      color: appColor(context).appTheme.stroke,
                                      width: 0)
                                  .padding(vertical: Sizes.s8),
                              TextWidgetCommon(
                                  text: "${rideCtrl.ratingValue ?? 3}/5")
                            ]).padding(all: Sizes.s12).decorated(
                                color: appColor(context).appTheme.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: appColor(context)
                                          .appTheme
                                          .primary
                                          .withValues(alpha: 0.03),
                                      blurRadius: 12,
                                      spreadRadius: 4)
                                ],
                                allRadius: Sizes.s10,
                                sideColor: appColor(context).appTheme.bgBox))
                      ]),
                Divider(color: appColor(context).appTheme.stroke, height: 0)
                    .padding(vertical: Sizes.s15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidgetCommon(
                          text: "Date",
                          color: appColor(context).appTheme.lightText),
                      TextWidgetCommon(
                          text: "${rideCtrl.date}, ${rideCtrl.time}"),
                    ]),
                VSpace(Sizes.s8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidgetCommon(
                          text: rideCtrl.status == "Pending"
                              ? "Trip ID"
                              : "Trip completed",
                          color: appColor(context).appTheme.lightText),
                      TextWidgetCommon(text: "${rideCtrl.id}")
                    ]),
                if (rideCtrl.status == "Pending")
                  Column(children: [
                    VSpace(Sizes.s8),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidgetCommon(
                              text: "Start ride pin",
                              color: appColor(context).appTheme.lightText),
                          Row(children: [
                            commonOTPContainer(context, "2"),
                            HSpace(Sizes.s4),
                            commonOTPContainer(context, "9"),
                            HSpace(Sizes.s4),
                            commonOTPContainer(context, "6"),
                            HSpace(Sizes.s4),
                            commonOTPContainer(context, "8")
                          ])
                        ])
                  ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextWidgetCommon(text: rideCtrl.carName),
                            VSpace(Sizes.s20),
                            Row(children: [
                              TextWidgetCommon(
                                  text: rideCtrl.code,
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
                RouteLocationDisplay(
                    data: rideCtrl.value,
                    loc1Color: appColor(context).appTheme.darkText),
                VSpace(Sizes.s25),
              ]).padding(horizontal: Sizes.s20),
              if (rideCtrl.status == 'Cancelled')
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const TextWidgetCommon(text: 'Cancellation Reason'),
                  VSpace(Sizes.s8),
                  const TextWidgetCommon(text: 'Ride Fare')
                ]).padding(horizontal: Sizes.s20, bottom: Sizes.s50),
              if (rideCtrl.status == 'Pending')
                CompleteRideWidget()
                    .billSummaryLayout(context)
                    .padding(bottom: Sizes.s50),
              if (rideCtrl.status == 'Complete')
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  CompleteRideWidget().billSummaryLayout(context),
                  const TextWidgetCommon(
                          text: 'Payment Method', fontWeight: FontWeight.w500)
                      .padding(
                          top: Sizes.s20,
                          bottom: Sizes.s8,
                          horizontal: Sizes.s20),
                  Column(children: [
                    CompleteRideWidget().rowCommonTextLayout(
                        title: "Payment ID", value: "#0111"),
                    CompleteRideWidget()
                        .rowCommonTextLayout(
                            title: "Method type", value: "cash")
                        .padding(vertical: Sizes.s15),
                    CompleteRideWidget()
                        .rowCommonTextLayout(title: "Status", value: "Paid")
                  ])
                      .padding(horizontal: Sizes.s20, vertical: Sizes.s20)
                      .decorated(
                          image: DecorationImage(
                              image: AssetImage(imageAssets.paymentMethodBG),
                              fit: BoxFit.fitWidth)),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SvgPicture.asset(svgAssets.download),
                    HSpace(Sizes.s10),
                    const TextWidgetCommon(text: 'Download Invoice')
                  ])
                      .padding(vertical: Sizes.s11)
                      .decorated(
                          allRadius: Sizes.s6,
                          color: appColor(context).appTheme.bgBox)
                      .padding(
                          horizontal: Sizes.s20,
                          top: Sizes.s25,
                          bottom: Sizes.s20)
                ])
            ]),
            CompleteRideWidget().appBarLayout()
          ])));
    });
  }

  Widget commonOTPContainer(context, String? text) {
    return Container(
        height: Sizes.s18,
        width: Sizes.s18,
        decoration: BoxDecoration(
            color: appColor(context).appTheme.yellowIcon,
            shape: BoxShape.circle),
        child: TextWidgetCommon(text: text).center());
  }
}
