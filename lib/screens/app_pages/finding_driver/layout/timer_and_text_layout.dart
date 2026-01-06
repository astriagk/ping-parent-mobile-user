import '../../../../config.dart';

class TimerAndTextLayout extends StatelessWidget {
  const TimerAndTextLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FindingDriverProvider>(
        builder: (context, findingCtrl, child) {
      return IntrinsicHeight(
              child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            findingCtrl.isCountDown
                ? Row(children: [
                    TextWidgetCommon(
                        text: appFonts.driversRespondWithin,
                        fontSize: Sizes.s12,
                        color: appColor(context).appTheme.white),
                    VerticalDivider(color: appColor(context).appTheme.white),
                    SvgPicture.asset(svgAssets.alarm),
                    findingCtrl.isCountDown
                        ? TextWidgetCommon(
                            text: "${findingCtrl.min} : ${findingCtrl.sec}",
                            style: AppCss.lexendLight12
                                .textColor(appColor(context).appTheme.white))
                        : TextWidgetCommon(
                            text: "00:00",
                            color: appColor(context).appTheme.white)
                  ])
                : Expanded(
                    child: TextWidgetCommon(
                        textAlign: TextAlign.center,
                        style: AppCss.lexendRegular12
                            .textColor(appTheme.white)
                            .textHeight(1.5),
                        text: appFonts.thePricingAndDepartureTime,
                        color: appColor(context).appTheme.white))
          ])
                  .padding(vertical: Sizes.s15, horizontal: Sizes.s25)
                  .backgroundColor(appColor(context).appTheme.primary))
          .padding(top: Sizes.s15, bottom: Sizes.s25);
    });
  }
}
