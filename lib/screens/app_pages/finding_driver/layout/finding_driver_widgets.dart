import '../../../../config.dart';

class FindingDriverWidgets {
//slider button layout
  Widget sliderButtonLayout(context) {
    return SizedBox(
            height: Sizes.s48,
            child: SliderButton(
                    action: () async {
                      route.pop(context);
                      return true;
                    },
                    label: TextWidgetCommon(
                            text: appFonts.slideToCancel, fontSize: Sizes.s16)
                        .center(),
                    icon: SvgPicture.asset(svgAssets.doubleArrowRight),
                    radius: 9,
                    alignLabel: Alignment.center,
                    height: 60,
                    buttonColor: appColor(context).appTheme.primary,
                    backgroundColor: appColor(context).appTheme.bgBox,
                    highlightedColor: Colors.white)
                .marginSymmetric(horizontal: Sizes.s20))
        .padding(bottom: Sizes.s20);
  }

//divider layout
  Widget dividerLayout(context) =>
      Divider(color: appColor(context).appTheme.stroke, height: 0)
          .padding(vertical: Sizes.s15);

  //rating ,user rating layout
  Widget ratingUserRatingLayout(e, context) => Row(children: [
        SvgPicture.asset(svgAssets.star, height: Sizes.s13, width: Sizes.s13),
        HSpace(Sizes.s4),
        TextWidgetCommon(text: e['rating'], fontSize: Sizes.s12),
        TextWidgetCommon(
            text: e['userRating'],
            fontSize: Sizes.s12,
            color: appColor(context).appTheme.lightText),
      ]);

//image, ride type layout
  Widget imageRideType(e) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Image.asset(e['image'], width: Sizes.s56),
        TextWidgetCommon(text: e['rideType']),
      ]);

  //driver name ,time layout
  Widget driverNameTimeLayout(e, context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextWidgetCommon(text: e['driverName'], fontSize: Sizes.s12),
      Row(children: [
        SvgPicture.asset(svgAssets.clockLight),
        HSpace(Sizes.s2),
        TextWidgetCommon(
            fontSize: Sizes.s12,
            text: e['dateTime'],
            color: appColor(context).appTheme.lightText)
      ])
    ]).padding(top: Sizes.s8, bottom: Sizes.s6);
  }
}
