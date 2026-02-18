import 'package:taxify_user_ui/api/enums/trip_status.dart';
import 'package:taxify_user_ui/api/enums/trip_type.dart';
import 'package:taxify_user_ui/api/models/trip_tracking_response.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/subscriptions_provider.dart';
import 'package:taxify_user_ui/widgets/common_confirmation_dialog.dart';

import '../../../../config.dart';
import '../../../../helper/date_formatter_helper.dart';

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
        ).inkWell(onTap: () => _onTap(context, homeCtrl));
      },
    );
  }

  Future<void> _onTap(BuildContext context, HomeScreenProvider homeCtrl) async {
    try {
      final subscriptionsCtrl = context.read<SubscriptionsProvider>();
      final hasSubscription =
          await subscriptionsCtrl.checkHasActiveSubscription();

      if (!hasSubscription) {
        if (context.mounted) {
          route.pushNamed(context, routeName.subscriptionManagementScreen);
        }
        return;
      }

      await homeCtrl.fetchTrackingData();

      final trips = homeCtrl.trackingData?.data ?? [];

      final activeTrips = trips
          .where((t) =>
              t.tripStatus == TripStatus.started ||
              t.tripStatus == TripStatus.inProgress)
          .toList();

      if (!context.mounted) return;

      if (activeTrips.isEmpty) {
        _showDialog(context,
            title: 'No Trips Available',
            message: 'There are no trips to track at the moment');
        return;
      }

      final acceptRideCtrl = context.read<AcceptRideProvider>();
      await acceptRideCtrl.loadCurrentUserId();

      if (!context.mounted) return;

      if (activeTrips.length == 1) {
        acceptRideCtrl.setCurrentTrip(activeTrips.first);
        route.pushNamed(context, routeName.acceptRideScreen);
      } else {
        _showTripSelectionSheet(
            context, activeTrips, acceptRideCtrl, acceptRideCtrl.currentUserId);
      }
    } catch (e) {
      if (context.mounted) {
        _showDialog(context,
            title: 'Error',
            message: 'Error fetching tracking data. Please try again.');
      }
    }
  }

  void _showTripSelectionSheet(
    BuildContext context,
    List<Trip> trips,
    AcceptRideProvider acceptRideCtrl,
    String? currentUserId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (sheetCtx, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: appColor(context).appTheme.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(Sizes.s24)),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: Sizes.s40,
                  height: Sizes.s4,
                  margin: EdgeInsets.only(top: Sizes.s12, bottom: Sizes.s16),
                  decoration: BoxDecoration(
                    color: appColor(context)
                        .appTheme
                        .hintText
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(Sizes.s2),
                  ),
                ),
                // Header banner
                Container(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.s20),
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes.s16, vertical: Sizes.s14),
                  decoration: BoxDecoration(
                    color: appColor(context).appTheme.white,
                    borderRadius: BorderRadius.circular(Sizes.s12),
                    boxShadow: [
                      BoxShadow(
                        color: appColor(context)
                            .appTheme
                            .primary
                            .withValues(alpha: 0.04),
                        blurRadius: 12,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(Sizes.s8),
                        decoration: BoxDecoration(
                          color: appColor(context).appTheme.bgBox,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.directions_bus_rounded,
                          color: appColor(context).appTheme.darkText,
                          size: Sizes.s18,
                        ),
                      ),
                      HSpace(Sizes.s12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidgetCommon(
                              text: '${trips.length} Active Trips',
                              style: AppCss.lexendSemiBold16.textColor(
                                  appColor(context).appTheme.darkText),
                            ),
                            VSpace(Sizes.s2),
                            TextWidgetCommon(
                              text:
                                  'Tap a trip below to view real-time tracking',
                              style: AppCss.lexendRegular12.textColor(
                                  appColor(context).appTheme.hintText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                VSpace(Sizes.s16),
                // Trip list
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
                    itemCount: trips.length,
                    separatorBuilder: (_, __) => VSpace(Sizes.s12),
                    itemBuilder: (_, index) {
                      final trip = trips[index];
                      final studentNames = trip.students
                          .map((s) => s.studentName ?? '')
                          .where((n) => n.isNotEmpty)
                          .join(', ');
                      final driverName = trip.driver?.name ?? 'Unknown Driver';
                      // Find the parent's waypoint for ETA
                      final parentWaypoint = currentUserId != null
                          ? trip.optimizedRouteData?.waypoints
                              .cast<Waypoint?>()
                              .firstWhere(
                                (w) => w?.parentUserId == currentUserId,
                                orElse: () => null,
                              )
                          : null;
                      final eta = parentWaypoint?.estimatedArrivalTime;
                      return _TripTile(
                        studentNames: studentNames.isNotEmpty
                            ? studentNames
                            : 'Trip ${index + 1}',
                        driverName: driverName,
                        tripType: trip.tripType,
                        studentCount: trip.students.length,
                        estimatedArrival: eta,
                        onTap: () {
                          acceptRideCtrl.setCurrentTrip(trip);
                          Navigator.pop(sheetCtx);
                          route.pushNamed(context, routeName.acceptRideScreen);
                        },
                      );
                    },
                  ),
                ),
                VSpace(Sizes.s24),
              ],
            ),
          );
        },
      ),
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

class _TripTile extends StatelessWidget {
  final String studentNames;
  final String driverName;
  final TripType tripType;
  final int studentCount;
  final String? estimatedArrival;
  final VoidCallback onTap;

  const _TripTile({
    required this.studentNames,
    required this.driverName,
    required this.tripType,
    required this.studentCount,
    required this.onTap,
    this.estimatedArrival,
  });

  Color _typeColor(BuildContext context) => tripType == TripType.pickup
      ? appColor(context).appTheme.success
      : appColor(context).appTheme.yellowIcon;

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(context);
    final typeLabel = tripType == TripType.pickup ? 'Pickup' : 'Drop-off';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Sizes.s12),
      child: Container(
        decoration: BoxDecoration(
          color: appColor(context).appTheme.white,
          borderRadius: BorderRadius.circular(Sizes.s12),
          boxShadow: [
            BoxShadow(
              color: appColor(context).appTheme.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Sizes.s14, vertical: Sizes.s14),
          child: Row(
            children: [
              // Bus icon
              Container(
                padding: EdgeInsets.all(Sizes.s10),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_bus_rounded,
                  color: typeColor,
                  size: Sizes.s20,
                ),
              ),
              HSpace(Sizes.s12),
              // Trip info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student names + type badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            studentNames,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppCss.lexendMedium14
                                .textColor(appColor(context).appTheme.darkText),
                          ),
                        ),
                        HSpace(Sizes.s8),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Sizes.s8, vertical: Sizes.s3),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(Sizes.s20),
                          ),
                          child: TextWidgetCommon(
                            text: typeLabel,
                            style: AppCss.lexendMedium10.textColor(typeColor),
                          ),
                        ),
                      ],
                    ),
                    VSpace(Sizes.s4),
                    // Driver name
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: Sizes.s13,
                          color: appColor(context).appTheme.hintText,
                        ),
                        HSpace(Sizes.s4),
                        TextWidgetCommon(
                          text: driverName,
                          style: AppCss.lexendRegular12
                              .textColor(appColor(context).appTheme.hintText),
                        ),
                      ],
                    ),
                    VSpace(Sizes.s4),
                    // Student count + ETA
                    Row(
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: Sizes.s13,
                          color: appColor(context).appTheme.hintText,
                        ),
                        HSpace(Sizes.s4),
                        Flexible(
                          child: Text(
                            [
                              '$studentCount student${studentCount == 1 ? '' : 's'}',
                              if (estimatedArrival != null)
                                'ETA ${DateFormatterHelper.formatTo12HourTime(estimatedArrival) ?? estimatedArrival!}',
                            ].join('  •  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppCss.lexendRegular12
                                .textColor(appColor(context).appTheme.hintText),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: Sizes.s14,
                color: appColor(context).appTheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
