import 'package:taxify_user_ui/widgets/common_bg_layout.dart';

import '../../../../config.dart';

class OutStationWidgets {
  //common payment layout
  Widget commonPaymentLayout(context,
      {bool? isSelect, GestureTapCallback? onTap}) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: CommonBgLayout(
              borderClr: appTheme.primary,
              isBorder: isSelect,
              color: appColor(context).appTheme.bgBox,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SvgPicture.asset(svgAssets.coin),
                HSpace(Sizes.s6),
                TextWidgetCommon(text: "Cash")
              ])).inkWell(onTap: onTap)),
      HSpace(Sizes.s10),
      Expanded(
          child: CommonBgLayout(
              borderClr: appTheme.primary,
              isBorder: !isSelect!,
              color: appColor(context).appTheme.bgBox,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SvgPicture.asset(svgAssets.scan),
                HSpace(Sizes.s6),
                TextWidgetCommon(text: "QR-Payment")
              ])).inkWell(onTap: onTap))
    ]);
  }

//common text layout
  Widget commonTextLayout(context, {String? title, String? hintText}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(text: title, fontWeight: FontWeight.w500)
          .padding(bottom: Sizes.s8, top: Sizes.s15),
      TextFieldCommon(
          hintText: hintText,
          color:
              appColor(context).appTheme.bgBox) /*.padding(bottom: Sizes.s15)*/,
    ]);
  }

//common label Minimum price for this fare.. text layout
  Widget commonLabelDesign(context) {
    final paragraph =
        'Minimum Price For This Fare Is \$80 Per Ride. You Can Bid Your Price Below';
    final highlightedText = '\$80';
    final parts = paragraph.split(highlightedText);
    TextStyle commonTextStyle(BuildContext context,
        {TextDecoration? decoration,
        double? fontHeight,
        Color? color,
        double? fontSize,
        double? decorationThickness,
        FontWeight? fontWeight}) {
      return TextStyle(
          decoration: decoration ?? TextDecoration.none,
          height: fontHeight ?? 1.2,
          color: color ?? appColor(context).appTheme.darkText,
          fontSize: fontSize ?? Sizes.s14,
          decorationThickness: decorationThickness,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: GoogleFonts.lexend().fontFamily);
    }

    return Column(children: [
      // TextWidgetCommon(
      //         text: appFonts.minimumPriceFor,
      //         fontSize: Sizes.s12,
      //         textAlign: TextAlign.center,
      //         fontWeight: FontWeight.w600)
      //     .padding(horizontal: Sizes.s30, vertical: Sizes.s8),
      RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: commonTextStyle(context), children: [
                TextSpan(text: parts[0], style: commonTextStyle(context)),
                TextSpan(
                    text: highlightedText,
                    style:
                        commonTextStyle(context, fontWeight: FontWeight.w600)),
                TextSpan(text: parts[1], style: commonTextStyle(context))
              ]))
          .padding(horizontal: 12, vertical: 8)
          .decorated(
              color: appColor(context).appTheme.stroke,
              sideColor:
                  appColor(context).appTheme.dashColor.withValues(alpha: 0.5),
              allRadius: Sizes.s6)
          .padding(vertical: Sizes.s15)
    ]);
  }

  //appBar layout
  Widget appBarLayout(context) {
    return Row(children: [
      CommonIconButton(icon: svgAssets.back, onTap: () => route.pop(context)),
      Expanded(
          child: TextWidgetCommon(
                  text: appFonts.outStation,
                  fontSize: Sizes.s18,
                  fontWeight: FontWeight.w500)
              .center())
    ]);
  }

  //add new Location TextField layout
  Widget addLocationLayout(context) {
    return IntrinsicHeight(
        child: Row(children: [
      //add icon with TextField layout
      SearchLocationWidgets().addIconLayout(),
      HSpace(Sizes.s10),
      //add new TextField layout
      SearchLocationWidgets().addTextFieldLayout()
    ]).padding(horizontal: Sizes.s15).decorated(
            allRadius: Sizes.s10, color: appColor(context).appTheme.white));
  }

  Widget faresDoNotInclude(context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SvgPicture.asset(svgAssets.drivingRed),
      HSpace(Insets.i6),
      TextWidgetCommon(
          text: appFonts.faresDoNot,
          color: appColor(context).appTheme.alertZone)
    ]).padding(vertical: Sizes.s9, horizontal: Sizes.s20).decorated(
        allRadius: Sizes.s5,
        color: appColor(context).appTheme.alertZone.withValues(alpha: 0.10));
  }

  //number of passenger and Enter total passenger  dropdown layout
  Widget numberOfPassenger() {
    return Consumer<OutStationProvider>(builder: (context, outCtrl, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextWidgetCommon(
                text: appFonts.numberOfPassenger, fontWeight: FontWeight.w500)
            .padding(bottom: Sizes.s8, top: Sizes.s15),
        CommonDropDownMenu(
            bgColor: appColor(context).appTheme.bgBox,
            isSVG: true,
            icon: SvgPicture.asset(svgAssets.arrowDown),
            value: outCtrl.passenger,
            onChanged: (newValue) => outCtrl.passengerValueChange(newValue),
            hintText: appFonts.enterTotalPassengerNo,
            itemsList: outCtrl.passengerDropDownItems
                .map((item) => DropdownMenuItem<dynamic>(
                    value: item['value'],
                    child: TextWidgetCommon(text: item['label'])))
                .toList())
      ]);
    });
  }

  //select payment method text layout
  Widget paymentLayout(context) {
    return Consumer<OutStationProvider>(builder: (context, outCtrl, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgetCommon(text: appFonts.paymentMethod)
              .padding(bottom: Sizes.s8, top: Sizes.s15),
          OutStationWidgets().commonPaymentLayout(context,
              isSelect: outCtrl.isPayment,
              onTap: () => outCtrl.selectPayment()),
        ],
      );
    });
  }
}
