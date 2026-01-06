import '../../../config.dart';

class CompleteRideWidget {
  Widget rowCommonTextLayout({String? title, String? value}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextWidgetCommon(text: title, fontWeight: FontWeight.w400),
      TextWidgetCommon(
          fontWeight: FontWeight.w400,
          text: value,
          color: value == "Paid" ? appTheme.alertZone : null)
    ]);
  }

  Widget billSummaryLayout(context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const TextWidgetCommon(text: 'Bill Summary', fontWeight: FontWeight.w500)
          .padding(bottom: Sizes.s15, horizontal: Sizes.s20),
      Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const TextWidgetCommon(text: 'Ride Fare'),
          TextWidgetCommon(
              text:
                  "${getSymbol(context)}${(currency(context).currencyVal * double.parse("46")).toStringAsFixed(0)}")
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const TextWidgetCommon(
              text: 'Total Access Fee', fontWeight: FontWeight.w400),
          TextWidgetCommon(
              fontWeight: FontWeight.w400,
              text:
                  "${getSymbol(context)}${(currency(context).currencyVal * double.parse("4")).toStringAsFixed(0)}")
        ]).padding(vertical: Sizes.s15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const TextWidgetCommon(
              text: 'Coupon Savings', fontWeight: FontWeight.w400),
          TextWidgetCommon(
              fontWeight: FontWeight.w400,
              color: appColor(context).appTheme.alertZone,
              text:
                  "-${getSymbol(context)}${(currency(context).currencyVal * double.parse("11")).toStringAsFixed(0)}")
        ]),
        Divider(height: 0, color: appColor(context).appTheme.lightText)
            .padding(top: Sizes.s15, bottom: Sizes.s12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const TextWidgetCommon(
              text: 'Total Bill', fontWeight: FontWeight.w400),
          TextWidgetCommon(
              fontWeight: FontWeight.w400,
              color: appColor(context).appTheme.success,
              text:
                  "${getSymbol(context)}${(currency(context).currencyVal * double.parse("39")).toStringAsFixed(0)}")
        ])
      ]).padding(horizontal: Sizes.s20, vertical: Sizes.s20).decorated(
          image: DecorationImage(
              image: AssetImage(imageAssets.billSummary), fit: BoxFit.fitWidth))
    ]);
  }

  Widget appBarLayout() =>
      Consumer<CompletedRideProvider>(builder: (context, rideCtrl, child) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CommonIconButton(
                icon: svgAssets.back, onTap: () => route.pop(context)),
            TextWidgetCommon(
                text: rideCtrl.status == "Complete"
                    ? "Completed Ride"
                    : rideCtrl.status == "Pending"
                        ? "Pending Ride"
                        : "Cancel Ride",
                textAlign: TextAlign.center,
                style: AppCss.lexendSemiBold20
                    .textColor(appColor(context).appTheme.darkText)),
            Container(),
            Container()
          ]).rideAppBarExtension(context)
        ]);
      });
}
