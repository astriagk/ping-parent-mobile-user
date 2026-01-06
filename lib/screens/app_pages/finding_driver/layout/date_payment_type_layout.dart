import '../../../../config.dart';
//date, payment type layout
class DatePaymentTypeLayout extends StatelessWidget {
  final dynamic data;

  const DatePaymentTypeLayout({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        SvgPicture.asset(svgAssets.clockLight),
        HSpace(Sizes.s3),
        TextWidgetCommon(
            text: data['date'],
            color: appColor(context).appTheme.lightText,
            fontSize: Sizes.s12),
        VerticalDivider(color: appColor(context).appTheme.lightText, width: 0)
            .padding(vertical: Sizes.s2, horizontal: Sizes.s5),
        TextWidgetCommon(
            text: data['time'],
            color: appColor(context).appTheme.lightText,
            fontSize: Sizes.s12),
      ]),
      HSpace(Sizes.s10),
      TextWidgetCommon(
          text: data['paymentType'],
          fontSize: Sizes.s12,
          color: appColor(context).appTheme.lightText)
    ]));
  }
}
