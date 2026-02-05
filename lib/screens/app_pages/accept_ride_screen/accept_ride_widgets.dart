import 'package:taxify_user_ui/config.dart';
import 'dart:convert';

class AcceptRideWidgets {
  driverDetailsAndOtp() =>
      Consumer<AcceptRideProvider>(builder: (context, acceptCtrl, child) {
        final acceptCtrlData = {
          'driverProfile': acceptCtrl.driverProfile,
          'isPayment': acceptCtrl.isPayment,
          'isRetry': acceptCtrl.isRetry,
          'isDrag': acceptCtrl.isDrag,
        };
        print('acceptCtrl JSON: ${jsonEncode(acceptCtrlData)}');
        return StatefulWrapper(
            onInit: () => Future.delayed(DurationClass.ms150)
                .then((value) => acceptCtrl.getArgument(context)),
            child: Column(children: [
              Row(children: [
                Image.asset(
                    "${acceptCtrl.driverProfile ?? imageAssets.profileImg}",
                    height: Sizes.s46,
                    width: Sizes.s46),
                HSpace(Sizes.s8),
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              TextWidgetCommon(text: 'Driver Name'),
                              HSpace(Sizes.s4),
                              SvgPicture.asset(svgAssets.infoCircle).inkWell(
                                  onTap: () => route.pushNamed(
                                      context, routeName.driverDetailScreen))
                            ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    SvgPicture.asset(svgAssets.star),
                                    HSpace(Sizes.s6),
                                    TextWidgetCommon(text: '4.5'),
                                    TextWidgetCommon(
                                        text: '(120)',
                                        color: appColor(context)
                                            .appTheme
                                            .lightText)
                                  ])
                                ])
                          ]),
                      Row(children: [
                        Container(
                                height: Sizes.s34,
                                width: Sizes.s34,
                                decoration: BoxDecoration(
                                    color: appColor(context).appTheme.bgBox,
                                    shape: BoxShape.circle),
                                child: SvgPicture.asset(svgAssets.messagesDark)
                                    .paddingDirectional(all: Sizes.s7))
                            .inkWell(
                                onTap: () => route.pushNamed(
                                    context, routeName.chatScreen)),
                        HSpace(Sizes.s10),
                        Container(
                            height: Sizes.s34,
                            width: Sizes.s34,
                            decoration: BoxDecoration(
                                color: appColor(context).appTheme.bgBox,
                                shape: BoxShape.circle),
                            child: SvgPicture.asset(svgAssets.call)
                                .paddingDirectional(all: Sizes.s7))
                      ])
                    ]))
              ]),
              VSpace(Sizes.s15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(children: [
                            TextWidgetCommon(
                                text: 'CLMV069',
                                fontSize: Sizes.s18,
                                fontWeight: FontWeight.w600),
                            HSpace(Sizes.s6),
                            SvgPicture.asset(svgAssets.car, height: Insets.i17)
                          ]),
                          VSpace(Sizes.s4),
                          TextWidgetCommon(
                              text: 'Car Name',
                              fontWeight: FontWeight.w400,
                              fontSize: Sizes.s14)
                        ]),
                    acceptCtrl.isPayment == true
                        ? Row(children: [
                            SvgPicture.asset(svgAssets.shareRide),
                            HSpace(Sizes.s4),
                            const TextWidgetCommon(text: "Share Trip")
                          ])
                        : Column(children: [
                            Row(children: [
                              commonOTPContainer(context, "2"),
                              HSpace(Sizes.s4),
                              commonOTPContainer(context, "9"),
                              HSpace(Sizes.s4),
                              commonOTPContainer(context, "6"),
                              HSpace(Sizes.s4),
                              commonOTPContainer(context, "8")
                            ]),
                            VSpace(Sizes.s4),
                            const TextWidgetCommon(
                                text: "Start Ride PIN",
                                fontWeight: FontWeight.w400)
                          ])
                  ]),
              Divider(height: 0, color: appColor(context).appTheme.stroke)
                  .paddingDirectional(vertical: Sizes.s20),
              acceptCtrl.isPayment == true
                  ? Container()
                  : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Row(children: [
                            SvgPicture.asset(svgAssets.locationSearch),
                            HSpace(Sizes.s6),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextWidgetCommon(text: "Torento"),
                                  TextWidgetCommon(
                                      text: "4:36pm · Drop off",
                                      color:
                                          appColor(context).appTheme.lightText,
                                      fontWeight: FontWeight.w300,
                                      fontSize: Sizes.s12)
                                ])
                          ]),
                          TextWidgetCommon(
                              fontHeight: 0.4,
                              text: "Changes",
                              textDecoration: TextDecoration.underline,
                              fontSize: Sizes.s12,
                              fontWeight: FontWeight.w600)
                        ])
                      .paddingDirectional(
                          vertical: Sizes.s12, horizontal: Sizes.s15)
                      .decorated(
                          color: appColor(context).appTheme.bgBox,
                          allRadius: Sizes.s6)
                      .inkWell(onTap: () {
                      acceptCtrl.isPayment = true;
                      // acceptCtrl.notifyListeners(); // Removed: Only call within provider
                    }),
              acceptCtrl.isRetry == true
                  ? Text("Complete transection within 0:48 min",
                          style: AppCss.lexendMedium14
                              .textColor(appTheme.alertZone))
                      .alignment(Alignment.centerLeft)
                      .padding(bottom: Insets.i8)
                  : Container(),
              if (acceptCtrl.isPayment == true)
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "Total Fare",
                                  style: AppCss.lexendMedium16.textColor(
                                      appColor(context).appTheme.primary)),
                              TextSpan(
                                  text: " \$100",
                                  style: AppCss.lexendSemiBold16.textColor(
                                      appColor(context).appTheme.darkText))
                            ]))),
                        acceptCtrl.isRetry == true
                            ? Expanded(
                                flex: 1,
                                child: CommonButton(
                                    style: AppCss.lexendMedium12
                                        .textColor(appTheme.white),
                                    height: 35,
                                    width: 86,
                                    text: "Pay Now",
                                    onTap: () {
                                      route.pushNamed(context,
                                          routeName.reviewDriverScreen);
                                    }))
                            : Expanded(
                                flex: 1,
                                child: CommonButton(
                                    style: AppCss.lexendMedium12
                                        .textColor(appTheme.white),
                                    height: 35,
                                    width: 86,
                                    text: "Retry",
                                    onTap: () {
                                      acceptCtrl.isRetry = true;
                                      // acceptCtrl.notifyListeners(); // Removed: Only call within provider
                                    }))
                      ]).padding(all: 12),
                  Divider(height: 0, color: appColor(context).appTheme.stroke)
                      .padding(bottom: 12),
                  Row(children: [
                    SvgPicture.asset("assets/svg/home/gpay.svg"),
                    const SizedBox(width: 8),
                    // Email and description
                    Expanded(
                        flex: 2,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('miketorello@okamerican',
                                  style: AppCss.lexendMedium14),
                              SizedBox(height: 4),
                              Text(appFonts.payNowToAvoid,
                                  style: AppCss.lexendLight12
                                      .textColor(Color(0xff797D83)))
                            ]))
                  ]).padding(horizontal: Insets.i12, bottom: Insets.i10)
                ]).decorated(
                    color: appColor(context).appTheme.bgBox,
                    allRadius: Sizes.s6),
              if (acceptCtrl.isDrag == true && acceptCtrl.isPayment == false)
                Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidgetCommon(
                            text: "Total Fare \$100",
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.s16),
                        Row(children: [
                          SvgPicture.asset(svgAssets.shareRide),
                          HSpace(Sizes.s4),
                          const TextWidgetCommon(text: "Share Trip")
                        ])
                      ]).paddingDirectional(all: Sizes.s12),
                  Divider(height: 0, color: appColor(context).appTheme.stroke),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          SvgPicture.asset(svgAssets.dollarSquare),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidgetCommon(text: "Cash"),
                                TextWidgetCommon(
                                    text: 'Pay when the ride end',
                                    color: appColor(context).appTheme.lightText)
                              ])
                        ]),
                        TextWidgetCommon(
                            fontHeight: 0.4,
                            text: "Changes",
                            textDecoration: TextDecoration.underline,
                            fontSize: Sizes.s12,
                            fontWeight: FontWeight.w600)
                      ]).paddingDirectional(all: Sizes.s12)
                ])
                    .decorated(
                        color: appColor(context).appTheme.bgBox,
                        allRadius: Sizes.s6)
                    .paddingDirectional(top: Sizes.s15)
            ]));
      });

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
