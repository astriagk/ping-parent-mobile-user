import '../../config.dart';

class RouteLocationDisplay extends StatelessWidget {
  final dynamic data;
  final Color? loc1Color;

  const RouteLocationDisplay({
    super.key,
    this.data,
    this.loc1Color,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocation = data?["currentLocation"] ?? '';
    final addLocation = data?['addLocation'] ?? '';

    // Hide widget if both locations are empty
    if (currentLocation.isEmpty && addLocation.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
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
                if (currentLocation.isNotEmpty)
                  TextWidgetCommon(
                      text: currentLocation,
                      fontSize: Sizes.s13,
                      color: loc1Color ?? appColor(context).appTheme.lightText),
                if (currentLocation.isNotEmpty && addLocation.isNotEmpty)
                  DottedLine(dashColor: appColor(context).appTheme.stroke)
                      .padding(vertical: Sizes.s15),
                if (addLocation.isNotEmpty)
                  TextWidgetCommon(text: addLocation, fontSize: Sizes.s13)
              ])))
        ]),
      ],
    );
  }
}
