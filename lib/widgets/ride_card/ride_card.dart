import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/widgets/location/route_location_display.dart';
import 'package:taxify_user_ui/widgets/location/route_distance_display.dart';
import 'layout/ride_data_model.dart';
import 'layout/ride_header_section.dart';
import 'layout/ride_driver_info_section.dart';

class RideCard extends StatelessWidget {
  final RideDataModel rideData;
  final int index;
  final VoidCallback onTap;
  final String? profileImageUrl;

  const RideCard({
    super.key,
    required this.rideData,
    required this.index,
    required this.onTap,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Column(children: [
          RideHeaderSection(rideData: rideData),
          DottedLine(dashColor: appColor(context).appTheme.stroke)
              .padding(vertical: Sizes.s15),
          RideDriverInfoSection(
            rideData: rideData,
            profileImageUrl: profileImageUrl,
          ),
          VSpace(Sizes.s15),
          RouteLocationDisplay(
                  data: rideData.toMap(),
                  loc1Color: appColor(context).appTheme.darkText)
              .padding(horizontal: Sizes.s10, vertical: Sizes.s10)
              .decorated(
                  color: appColor(context).appTheme.bgBox, allRadius: Sizes.s8),
          if (rideData.distance != null) ...[
            VSpace(Sizes.s8),
            RouteDistanceDisplay(
              distance: rideData.distance,
              distanceColor: rideData.distanceColor,
            ),
          ]
        ]).myRideListExtension(context).padding(bottom: Sizes.s15));
  }
}
