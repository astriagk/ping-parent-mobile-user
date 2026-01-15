import '../config.dart';
import '../helper/distance_helper.dart';
import '../models/location_data.dart';

class LocationPreviewCard extends StatelessWidget {
  final List<LocationData> locations;
  final bool showBottomSpace;

  const LocationPreviewCard({
    super.key,
    required this.locations,
    this.showBottomSpace = true,
  });

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) return const SizedBox.shrink();

    // Calculate total distance through all locations
    double totalDistance = 0.0;
    for (int i = 0; i < locations.length - 1; i++) {
      totalDistance += DistanceHelper.calculateDistanceInKm(
        locations[i].latitude,
        locations[i].longitude,
        locations[i + 1].latitude,
        locations[i + 1].longitude,
      );
    }

    final distanceText = DistanceHelper.formatDistance(totalDistance);
    final distanceColor = DistanceHelper.getDistanceColor(
      totalDistance,
      appColor(context).appTheme.primary,
      appColor(context).appTheme.success,
      appColor(context).appTheme.yellowIcon,
      appColor(context).appTheme.alertZone,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VSpace(Sizes.s8),
        Row(children: [
          Column(children: [
            ...List.generate(locations.length, (index) {
              return Column(
                children: [
                  SvgPicture.asset(
                    index == locations.length - 1
                        ? svgAssets.gpsDestination
                        : svgAssets.locationSearch,
                  ),
                  if (index < locations.length - 1)
                    Dash(
                      length: 27,
                      dashGap: 1,
                      dashThickness: 2,
                      dashBorderRadius: 3,
                      direction: Axis.vertical,
                      dashColor: appColor(context).appTheme.lightText,
                    ),
                ],
              );
            }),
          ]),
          HSpace(Sizes.s10),
          Expanded(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(locations.length, (index) {
                    final location = locations[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidgetCommon(
                              text: location.name,
                              fontSize: Sizes.s13,
                              fontWeight: FontWeight.w500,
                            ),
                            if (location.address.isNotEmpty) ...[
                              VSpace(Sizes.s2),
                              TextWidgetCommon(
                                text: location.address,
                                fontSize: Sizes.s12,
                                color: appColor(context).appTheme.lightText,
                              )
                            ]
                          ],
                        ),
                        if (index < locations.length - 1)
                          DottedLine(
                                  dashColor: appColor(context).appTheme.stroke)
                              .padding(vertical: Sizes.s15),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ]).padding(horizontal: Sizes.s10, vertical: Sizes.s10).decorated(
            color: appColor(context).appTheme.bgBox, allRadius: Sizes.s8),
        VSpace(Sizes.s8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.directions, size: Sizes.s16, color: distanceColor),
          HSpace(Sizes.s6),
          TextWidgetCommon(
              text: 'Distance: $distanceText',
              fontSize: Sizes.s12,
              fontWeight: FontWeight.w500,
              color: distanceColor)
        ]),
        if (showBottomSpace) VSpace(Sizes.s16),
      ],
    );
  }
}
