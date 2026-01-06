import '../../../../config.dart';

class SelectRiderWidgets {
//vehicle type layout
  Widget vehicleType({bool? isRental}) {
    return Consumer2<SelectRiderProvider, RentalProvider>(
        builder: (context, riderCtrl, rentalCtrl, child) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: riderCtrl.vehicleType
                      .asMap()
                      .entries
                      .map(
                          (e) => //vehicle type image ,time, fareAway,title layout
                              VehicleTypeLayout(
                                  isRental: false,
                                  onTap: () => riderCtrl.onTap(e.key),
                                  infoOnTap: () => riderCtrl.infoOnTap(e.key),
                                  e: e,
                                  sideColor: e.key == riderCtrl.selectedIndex
                                      ? appColor(context).appTheme.primary
                                      : appColor(context).appTheme.trans))
                      .toList())));
    });
  }

//cancel ride dialog appBar layout
  Widget cancelRideAppBar(context) {
    return Consumer<CancelRideProvider>(builder: (context, cancelCtrl, child) {
      return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            GestureDetector(
                onTap: () => route.pop(context),
                child: Container(
                    height: Sizes.s40,
                    width: Sizes.s40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColor(context).appTheme.white),
                    child: SvgPicture.asset(svgAssets.back,
                        width: Sizes.s22,
                        height: Sizes.s22,
                        fit: BoxFit.scaleDown))),
            Material(
                color: appColor(context).appTheme.trans,
                child: TextWidgetCommon(
                        text: appFonts.cancelRide, fontWeight: FontWeight.w600)
                    .inkWell(onTap: () => cancelCtrl.dialogOnTap(context)))
          ])
          .paddingDirectional(
              horizontal: Sizes.s20, top: Sizes.s35, bottom: Sizes.s20)
          .authExtension(context);
    });
  }

  //cancel ride dialog image, CarName layout
  Widget imageCarNameLayout(e, context) {
    return Consumer<CancelRideProvider>(builder: (context, value, child) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Image.asset(e['image'], height: Sizes.s32, width: Sizes.s32),
          HSpace(Sizes.s8),
          TextWidgetCommon(text: e['carName'], fontWeight: FontWeight.w500)
        ]),
        TextWidgetCommon(
            text:
                "${getSymbol(context)}${(currency(context).currencyVal * double.parse(e['price'])).toStringAsFixed(0)}",
            color: appColor(context).appTheme.success,
            fontSize: Sizes.s15,
            fontWeight: FontWeight.w600)
      ]);
    });
  }

//driver name ,time layout
  Widget driverNameTimeLayout(e, context) {
    return Consumer<CancelRideProvider>(builder: (context, value, child) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TextWidgetCommon(text: e['driverName'], fontSize: Sizes.s12),
        TextWidgetCommon(
            text: e['time'], color: appColor(context).appTheme.lightText)
      ]).padding(top: Sizes.s8, bottom: Sizes.s6);
    });
  }

  //rating , userRating ,km layout
  Widget ratingUserRatingKmLayout(e, context) {
    return Consumer<CancelRideProvider>(builder: (context, value, child) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          SvgPicture.asset(svgAssets.star, height: Sizes.s13, width: Sizes.s13),
          HSpace(Sizes.s4),
          TextWidgetCommon(text: e['rating'], fontSize: Sizes.s12),
          TextWidgetCommon(
              text: e['userRating'],
              fontSize: Sizes.s12,
              color: appColor(context).appTheme.lightText)
        ]),
        TextWidgetCommon(
            text: e['km'],
            fontSize: Sizes.s12,
            color: appColor(context).appTheme.lightText)
      ]);
    });
  }

//skip and accept Button layout
  Widget skipAndAcceptButton(context,
      {GestureTapCallback? accept, GestureTapCallback? skip}) {
    return Consumer<CancelRideProvider>(builder: (context, value, child) {
      return Row(children: [
        Expanded(
            child: Material(
                child: CommonButton(
                        bgColor: Color(0xffF3F4F6),
                        text: appFonts.skip,
                        style: AppCss.lexendRegular14,
                        height: Insets.i38)
                    .inkWell(onTap: skip))),
        HSpace(Sizes.s13),
        Expanded(
            child: Material(
          child: CommonButton(text: appFonts.accept, height: Insets.i38)
              .inkWell(onTap: accept),
        ))
      ]).padding(top: Sizes.s12, bottom: Sizes.s8);
    });
  }

  //animated timing layout
  Widget animatedTimingLayout(context) =>
      Consumer<CancelRideProvider>(builder: (context, value, child) {
        return Container(
            width: MediaQuery.of(context).size.width,
            color: appColor(context).appTheme.stroke,
            height: Sizes.s3,
            child: LinearProgressIndicator(
                value: value.progress,
                color: appColor(context).appTheme.yellowIcon,
                backgroundColor: appColor(context).appTheme.stroke,
                borderRadius: BorderRadius.circular(Insets.i10)));
      });
}
