import '../../../config.dart';

class PromoWidgets {
//promo screen date and useNow layout
  Widget dateAndUseNowLayout(context, e) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextWidgetCommon(
          text: "${appFonts.validTill} :${e['date']}",
          fontSize: Sizes.s11,
          color: appColor(context).appTheme.lightText,
          fontWeight: FontWeight.w300),
      TextWidgetCommon(
          text: appFonts.useNow,
          textDecoration: TextDecoration.underline,
          fontHeight: 1.5,
          fontSize: Sizes.s12)
    ]);
  }
//promo screen off and code layout
  Widget offAndCodeLayout(e, context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextWidgetCommon(
          text: e['off'], fontSize: Sizes.s16, fontWeight: FontWeight.w600),
      TextWidgetCommon(
          text: e['code'],
          fontSize: Sizes.s13,
          color: appColor(context).appTheme.yellowIcon)
    ]);
  }
//promo screen fair price layout
  Widget fairPriceLayout(e, context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      VSpace(Sizes.s6),
      TextWidgetCommon(
          text: e['fairPrice'],
          color: appColor(context).appTheme.lightText,
          fontSize: Sizes.s12),
      DottedLine(dashColor: appColor(context).appTheme.stroke)
          .padding(top: Sizes.s15, bottom: Sizes.s10),
    ]);
  }
}
