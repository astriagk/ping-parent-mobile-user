import '../../../../config.dart';

class FindingLocationLayout extends StatelessWidget {
  final dynamic data;
  final Color? loc1Color;

  const FindingLocationLayout({super.key, this.data, this.loc1Color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Column(children: [
        SvgPicture.asset(svgAssets.locationSearch),
        Dash(
            length: 27,
            dashGap: 1,
            dashThickness: 2,
            dashBorderRadius: 3,
            direction: Axis.vertical,
            dashColor: appColor(context).appTheme.lightText),
        SvgPicture.asset(svgAssets.gpsDestination)
      ]),
      HSpace(Sizes.s10),
      Expanded(
          child: IntrinsicWidth(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            TextWidgetCommon(
                text: data["currentLocation"],
                fontSize: Sizes.s13,
                color: loc1Color ?? appColor(context).appTheme.lightText),
            DottedLine(dashColor: appColor(context).appTheme.stroke)
                .padding(vertical: Sizes.s15),
            TextWidgetCommon(text: data['addLocation'], fontSize: Sizes.s13)
          ])))
    ]);
  }
}
