import 'package:taxify_user_ui/api/enums/trip_status.dart';
import 'package:taxify_user_ui/api/models/trip_tracking_response.dart';
import 'package:taxify_user_ui/widgets/common_confirmation_dialog.dart';

import '../../../../config.dart';

class TrackingCard extends StatelessWidget {
  const TrackingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, homeCtrl, child) {
        return Container(
          decoration: BoxDecoration(
            color: appColor(context).appTheme.white,
            borderRadius: BorderRadius.circular(Sizes.s12),
            boxShadow: [
              BoxShadow(
                color:
                    appColor(context).appTheme.primary.withValues(alpha: 0.04),
                blurRadius: 12,
                spreadRadius: 4,
              )
            ],
          ),
          margin: EdgeInsets.symmetric(vertical: Sizes.s15),
          child: Row(
            children: [
              // Left side - Tracking info
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Sizes.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header
                      TextWidgetCommon(
                        text: 'View Your Tracking',
                        style: AppCss.lexendBold16
                            .textColor(appColor(context).appTheme.darkText),
                      ),
                      VSpace(Sizes.s8),
                      // Description
                      TextWidgetCommon(
                        text: 'Tap to see real-time tracking details',
                        style: AppCss.lexendRegular13
                            .textColor(appColor(context).appTheme.hintText),
                      ),
                      VSpace(Sizes.s12),
                      // Tap indicator
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
                            size: Sizes.s14,
                            color: appColor(context).appTheme.primary,
                          ),
                          HSpace(Sizes.s6),
                          TextWidgetCommon(
                            text: 'View Tracking',
                            style: AppCss.lexendMedium13
                                .textColor(appColor(context).appTheme.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Right side - Small map
              Container(
                width: Sizes.s110,
                height: Sizes.s140,
                margin: EdgeInsets.only(right: Sizes.s4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Sizes.s12),
                    bottomRight: Radius.circular(Sizes.s12),
                  ),
                  color: appColor(context)
                      .appTheme
                      .hintText
                      .withValues(alpha: 0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Sizes.s12),
                    bottomRight: Radius.circular(Sizes.s12),
                  ),
                  child: Stack(
                    children: [
                      // Map image
                      Image.asset(
                        imageAssets.trackingMap,
                        fit: BoxFit.cover,
                        width: Sizes.s120,
                        height: Sizes.s140,
                      ),
                      // Overlay with slight opacity
                      Container(
                        decoration: BoxDecoration(
                          color: appColor(context)
                              .appTheme
                              .primary
                              .withValues(alpha: 0.1),
                        ),
                      ),
                      // Center indicator
                      Center(
                        child: Container(
                          width: Sizes.s30,
                          height: Sizes.s30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: appColor(context)
                                .appTheme
                                .primary
                                .withValues(alpha: 0.8),
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: appColor(context).appTheme.white,
                            size: Sizes.s16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).inkWell(onTap: () async {
          try {
            // Call the API to fetch tracking data
            await homeCtrl.fetchTrackingData();

            final trips = homeCtrl.trackingData?.data ?? [];

            if (trips.isNotEmpty) {
              // Check if any trip has started or inprogress status
              Trip? activeTrip;
              try {
                activeTrip = trips.firstWhere((trip) =>
                    trip.tripStatus == TripStatus.started ||
                    trip.tripStatus == TripStatus.inProgress);
              } catch (e) {
                activeTrip = null;
              }

              if (activeTrip != null) {
                // Navigate to tracking screen if active trip found
                route.pushNamed(context, routeName.acceptRideScreen);
              } else {
                // Show dialog if no active trip to track
                if (context.mounted) {
                  _showDialog(
                    context,
                    title: 'No Trips Available',
                    message: 'No trips to track at the moment',
                  );
                }
              }
            } else {
              // Show dialog if no trips
              if (context.mounted) {
                _showDialog(
                  context,
                  title: 'No Trips Available',
                  message: 'There are no trips to track at the moment',
                );
              }
            }
          } catch (e) {
            if (context.mounted) {
              _showDialog(
                context,
                title: 'Error',
                message: 'Error fetching tracking data. Please try again.',
              );
            }
          }
        });
      },
    );
  }

  void _showDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomConfirmationDialog(
          message: message,
          // content: TextWidgetCommon(
          //   text: message,
          //   style: AppCss.lexendRegular14
          //       .textColor(appColor(dialogContext).appTheme.hintText),
          // ),
          onConfirm: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }
}
