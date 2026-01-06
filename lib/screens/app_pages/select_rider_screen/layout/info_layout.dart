import '../../../../config.dart';

class InfoLayout extends StatelessWidget {
  const InfoLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectRiderProvider>(builder: (context, riderCtrl, child) {
      var data = riderCtrl.vehicleType[riderCtrl.selectedIndex!];
      List dataList = data['data'];
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Row(children: [
                TextWidgetCommon(
                    text: data['title'],
                    fontSize: Sizes.s16,
                    fontWeight: FontWeight.w600),
                VerticalDivider(
                        color: appColor(context).appTheme.stroke, width: 0)
                    .padding(horizontal: Sizes.s6),
                SvgPicture.asset(svgAssets.profileDark),
                HSpace(Sizes.s2),
                TextWidgetCommon(text: data['person'], fontSize: Sizes.s13)
              ]),
              Row(children: [
                TextWidgetCommon(
                    text:
                        ' ${getSymbol(context)}${(currency(context).currencyVal * double.parse(data['amount'])).toStringAsFixed(0)}',
                    fontSize: Sizes.s18,
                    fontWeight: FontWeight.w600,
                    color: appColor(context).appTheme.success),
                HSpace(Sizes.s4),
                TextWidgetCommon(
                    text:
                        "${getSymbol(context)}${(currency(context).currencyVal * double.parse(data['closeAmount'])).toStringAsFixed(0)}",
                    textDecoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w300,
                    color: appColor(context).appTheme.lightText)
              ])
            ])),
        Divider(color: appColor(context).appTheme.stroke, height: 0)
            .padding(top: Sizes.s17, bottom: Sizes.s26),
        Image.asset(data['infoImage']).center(),
        Row(children: [
          SvgPicture.asset(svgAssets.clock),
          HSpace(Sizes.s4),
          TextWidgetCommon(text: data['awayTime'])
        ]).padding(top: Sizes.s22, bottom: Sizes.s6),
        TextWidgetCommon(
            text: data['advantage'],
            fontSize: Sizes.s12,
            color: appColor(context).appTheme.lightText),
        Divider(color: appColor(context).appTheme.stroke, height: 0)
            .padding(vertical: Sizes.s25),
        TextWidgetCommon(text: data['dataTitle']),
        VSpace(Sizes.s6),
        Column(children: [
          ...dataList.map((e) => TextWidgetCommon(
              text: "• $e",
              color: appColor(context).appTheme.lightText,
              fontSize: Sizes.s12,fontHeight: 1.5))
        ])
      ]).padding(horizontal: Sizes.s20,bottom: Sizes.s20).riderScreenBg(context);
    });
  }
}
