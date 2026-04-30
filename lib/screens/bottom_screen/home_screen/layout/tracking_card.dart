import 'package:skolo/api/enums/trip_status.dart';
import 'package:skolo/api/enums/trip_type.dart';
import 'package:skolo/api/models/trip_tracking_response.dart';
import 'package:skolo/provider/app_pages_providers/subscriptions_provider.dart';
import 'package:skolo/widgets/common_confirmation_dialog.dart';

import '../../../../config.dart';
import '../../../../helper/date_formatter_helper.dart';

class TrackingCard extends StatelessWidget {
  const TrackingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeScreenProvider, DashBoardProvider>(
      builder: (context, homeCtrl, bottomCtrl, child) {
        return Consumer<TripTrackingProvider>(
          builder: (context, tripCtrl, _) {
            return _CardShell(
              onTap: () => _onTap(context, homeCtrl, bottomCtrl),
              child: tripCtrl.isLoading
                  ? _LoadingState()
                  : tripCtrl.activeTrips.isEmpty
                      ? _NoTripsState()
                      : tripCtrl.activeTrips.length == 1
                          ? _SingleTripState(trip: tripCtrl.activeTrips.first)
                          : _MultiTripState(trips: tripCtrl.activeTrips),
            );
          },
        );
      },
    );
  }

  Future<void> _onTap(
      BuildContext context, HomeScreenProvider homeCtrl, bottomCtrl) async {
    try {
      final subscriptionsCtrl = context.read<SubscriptionsProvider>();
      final hasSubscription =
          await subscriptionsCtrl.checkHasActiveSubscription();

      if (!hasSubscription) {
        if (context.mounted) {
          bottomCtrl.tabChange(2);
        }
        return;
      }

      await homeCtrl.fetchTrackingData();

      if (!context.mounted) return;

      final trackingData = homeCtrl.trackingData;
      if (trackingData != null &&
          !trackingData.success &&
          trackingData.error != null) {
        _showDialog(context,
            title: 'Access Denied', message: trackingData.error!);
        return;
      }

      final trips = trackingData?.data ?? [];

      final activeTrips = trips
          .where((t) =>
              t.tripStatus == TripStatus.started ||
              t.tripStatus == TripStatus.inProgress)
          .toList();

      if (!context.mounted) return;

      if (activeTrips.isEmpty) return;

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
          onConfirm: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }
}

// ─── Card shell ──────────────────────────────────────────────────────────────

class _CardShell extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onTap;

  const _CardShell({required this.child, required this.onTap});

  @override
  State<_CardShell> createState() => _CardShellState();
}

class _CardShellState extends State<_CardShell> {
  bool _processing = false;

  Future<void> _handleTap() async {
    if (_processing) return;
    setState(() => _processing = true);
    try {
      await widget.onTap();
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Sizes.s16),
      decoration: BoxDecoration(
        color: appColor(context).appTheme.white,
        borderRadius: BorderRadius.circular(Sizes.s16),
        boxShadow: [
          BoxShadow(
            color: appColor(context).appTheme.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Sizes.s16),
        child: InkWell(
          onTap: _processing ? null : _handleTap,
          borderRadius: BorderRadius.circular(Sizes.s16),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── Loading state ────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizes.s12),
      child: Row(
        children: [
          SizedBox(
            width: Sizes.s18,
            height: Sizes.s18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: appColor(context).appTheme.primary,
            ),
          ),
          HSpace(Sizes.s12),
          TextWidgetCommon(
            text: 'Checking for active trips…',
            style: AppCss.lexendRegular13
                .textColor(appColor(context).appTheme.hintText),
          ),
        ],
      ),
    );
  }
}

// ─── No trips state ───────────────────────────────────────────────────────────

class _NoTripsState extends StatelessWidget {
  const _NoTripsState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s12, vertical: Sizes.s12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Sizes.s12),
            decoration: BoxDecoration(
              color: appColor(context).appTheme.bgBox,
              borderRadius: BorderRadius.circular(Sizes.s12),
            ),
            child: Icon(
              Icons.directions_bus_outlined,
              size: Sizes.s24,
              color: appColor(context).appTheme.hintText,
            ),
          ),
          HSpace(Sizes.s14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgetCommon(
                  text: 'No active trips',
                  style: AppCss.lexendSemiBold16
                      .textColor(appColor(context).appTheme.darkText),
                ),
                VSpace(Sizes.s4),
                TextWidgetCommon(
                  text: 'Live tracking will appear here when a trip starts',
                  style: AppCss.lexendRegular12
                      .textColor(appColor(context).appTheme.hintText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Single active trip ───────────────────────────────────────────────────────

class _SingleTripState extends StatelessWidget {
  final Trip trip;

  const _SingleTripState({required this.trip});

  @override
  Widget build(BuildContext context) {
    final isPickup = trip.tripType == TripType.pickup;
    final typeColor = isPickup
        ? appColor(context).appTheme.success
        : appColor(context).appTheme.yellowIcon;
    final typeLabel = isPickup ? 'Pickup' : 'Drop-off';

    final studentNames = trip.students
        .map((s) => s.studentName ?? '')
        .where((n) => n.isNotEmpty)
        .join(', ');

    final driverName = trip.driver?.name;

    final isLive = trip.tripStatus == TripStatus.started ||
        trip.tripStatus == TripStatus.inProgress;

    return Padding(
      padding: EdgeInsets.all(Sizes.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type badge + live indicator
                Row(
                  children: [
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
                    if (isLive) ...[
                      HSpace(Sizes.s8),
                      _LiveDot(),
                      HSpace(Sizes.s4),
                      TextWidgetCommon(
                        text: 'Live',
                        style: AppCss.lexendMedium10
                            .textColor(appColor(context).appTheme.success),
                      ),
                    ],
                  ],
                ),
                VSpace(Sizes.s8),
                // Student name
                Text(
                  studentNames.isNotEmpty ? studentNames : 'Your child',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppCss.lexendBold16
                      .textColor(appColor(context).appTheme.darkText),
                ),
                if (driverName != null) ...[
                  VSpace(Sizes.s4),
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded,
                          size: Sizes.s13,
                          color: appColor(context).appTheme.hintText),
                      HSpace(Sizes.s4),
                      Expanded(
                        child: Text(
                          driverName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppCss.lexendRegular12
                              .textColor(appColor(context).appTheme.hintText),
                        ),
                      ),
                    ],
                  ),
                ],
                VSpace(Sizes.s12),
                // CTA row
                Row(
                  children: [
                    TextWidgetCommon(
                      text: 'Track now',
                      style: AppCss.lexendSemiBold14
                          .textColor(appColor(context).appTheme.primary),
                    ),
                    HSpace(Sizes.s4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: Sizes.s14,
                      color: appColor(context).appTheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right: map thumbnail
          _MapThumbnail(),
        ],
      ),
    );
  }
}

// ─── Multiple active trips ────────────────────────────────────────────────────

class _MultiTripState extends StatelessWidget {
  final List<Trip> trips;

  const _MultiTripState({required this.trips});

  @override
  Widget build(BuildContext context) {
    final allStudents = trips
        .expand((t) => t.students)
        .map((s) => s.studentName ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .join(', ');

    return Padding(
      padding: EdgeInsets.all(Sizes.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _LiveDot(),
                    HSpace(Sizes.s6),
                    TextWidgetCommon(
                      text: '${trips.length} active trips',
                      style: AppCss.lexendSemiBold16
                          .textColor(appColor(context).appTheme.darkText),
                    ),
                  ],
                ),
                if (allStudents.isNotEmpty) ...[
                  VSpace(Sizes.s6),
                  Row(
                    children: [
                      Icon(Icons.group_outlined,
                          size: Sizes.s13,
                          color: appColor(context).appTheme.hintText),
                      HSpace(Sizes.s4),
                      Expanded(
                        child: Text(
                          allStudents,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppCss.lexendRegular12
                              .textColor(appColor(context).appTheme.hintText),
                        ),
                      ),
                    ],
                  ),
                ],
                VSpace(Sizes.s12),
                Row(
                  children: [
                    TextWidgetCommon(
                      text: 'View all trips',
                      style: AppCss.lexendSemiBold14
                          .textColor(appColor(context).appTheme.primary),
                    ),
                    HSpace(Sizes.s4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: Sizes.s14,
                      color: appColor(context).appTheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _MapThumbnail(),
        ],
      ),
    );
  }
}

// ─── Shared sub-widgets ───────────────────────────────────────────────────────

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.s7,
      height: Sizes.s7,
      decoration: BoxDecoration(
        color: appColor(context).appTheme.success,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _MapThumbnail extends StatelessWidget {
  const _MapThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.s90,
      height: Sizes.s110,
      margin: EdgeInsets.only(left: Sizes.s12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.s12),
        color: appColor(context).appTheme.bgBox,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.s12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageAssets.trackingMap,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                color:
                    appColor(context).appTheme.primary.withValues(alpha: 0.08),
              ),
            ),
            Center(
              child: Container(
                width: Sizes.s28,
                height: Sizes.s28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColor(context).appTheme.primary,
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: appColor(context).appTheme.white,
                  size: Sizes.s15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Trip tile (bottom sheet) ─────────────────────────────────────────────────

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
