import '../../config.dart';

class RouteDistanceDisplay extends StatelessWidget {
  final String? distance;
  final Color? distanceColor;

  const RouteDistanceDisplay({
    super.key,
    this.distance,
    this.distanceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.directions,
          size: Sizes.s16,
          color: distanceColor ?? appColor(context).appTheme.success),
      HSpace(Sizes.s6),
      TextWidgetCommon(
          text: 'Distance: $distance',
          fontSize: Sizes.s12,
          fontWeight: FontWeight.w500,
          color: distanceColor ?? appColor(context).appTheme.success)
    ]);
  }
}
