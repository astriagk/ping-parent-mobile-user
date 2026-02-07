import '../../../../config.dart';
import '../../../../api/models/trip_tracking_response.dart';
import '../../../../helper/date_formatter_helper.dart';

class CardLayout extends StatefulWidget {
  const CardLayout({super.key});

  @override
  State<CardLayout> createState() => _CardLayoutState();
}

class _CardLayoutState extends State<CardLayout> {
  @override
  void initState() {
    super.initState();
    _loadTrackingData();
  }

  Future<void> _loadTrackingData() async {
    if (mounted) {
      final homeProvider = context.read<HomeScreenProvider>();
      await homeProvider.fetchTrackingData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, homeCtrl, child) {
      final trips = homeCtrl.trackingData?.data ?? [];

      if (trips.isEmpty) {
        return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              Container(
                  decoration: BoxDecoration(
                      color: appColor(context).appTheme.white,
                      borderRadius: BorderRadius.circular(Sizes.s8),
                      boxShadow: [
                        BoxShadow(
                          color: appColor(context)
                              .appTheme
                              .primary
                              .withValues(alpha: 0.04),
                          blurRadius: 12,
                          spreadRadius: 4,
                        )
                      ]),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(Sizes.s8),
                      child: Stack(children: [
                        Image.asset(imageAssets.trackingMap,
                            fit: BoxFit.fill,
                            width: Sizes.s270,
                            height: Sizes.s140),
                        Positioned.fill(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: appColor(context)
                                      .appTheme
                                      .primary
                                      .withValues(alpha: 0.3),
                                ),
                                child: Center(
                                  child: TextWidgetCommon(
                                    text: 'No active trips',
                                    color: appColor(context).appTheme.white,
                                    fontSize: Sizes.s16,
                                  ),
                                )))
                      ]))),
              HSpace(Sizes.s15)
            ])).paddingSymmetric(vertical: Sizes.s25);
      }

      return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: trips
                      .asMap()
                      .entries
                      .map((e) => Row(children: [
                            _buildCardItem(context, homeCtrl, e.key, e.value),
                            if (e.key == 0) HSpace(Sizes.s15)
                          ]))
                      .toList()))
          .paddingSymmetric(vertical: Sizes.s25);
    });
  }

  Widget _buildCardItem(
      BuildContext context, HomeScreenProvider homeCtrl, int index, Trip trip) {
    return Container(
        decoration: BoxDecoration(
            color: appColor(context).appTheme.white,
            borderRadius: BorderRadius.circular(Sizes.s8),
            boxShadow: [
              BoxShadow(
                color:
                    appColor(context).appTheme.primary.withValues(alpha: 0.04),
                blurRadius: 12,
                spreadRadius: 4,
              )
            ]),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.s8),
            child: Stack(children: [
              Image.asset(imageAssets.trackingMap,
                  fit: BoxFit.fill, width: Sizes.s270, height: Sizes.s140),
              _buildTrackingOverlay(context, trip),
            ]))).inkWell(
        onTap: () => route.pushNamed(
              context,
              routeName.acceptRideScreen,
            ));
  }

  Widget _buildTrackingOverlay(BuildContext context, Trip trip) {
    final studentNames =
        trip.students.map((s) => s.studentName ?? '').join(', ');
    final estimatedArrivalTime =
        trip.optimizedRouteData?.waypoints.isNotEmpty ?? false
            ? trip.optimizedRouteData!.waypoints.first.estimatedArrivalTime
            : null;
    final formattedEta =
        DateFormatterHelper.formatTo12HourTime(estimatedArrivalTime) ?? 'N/A';

    return Positioned.fill(
        child: Container(
            decoration: BoxDecoration(
              color: appColor(context).appTheme.primary.withValues(alpha: 0.3),
            ),
            child: Padding(
                padding: EdgeInsets.all(Sizes.s12),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidgetCommon(
                                text:
                                    'Type: ${trip.tripType.toDisplayString()}',
                                color: appColor(context).appTheme.white,
                                fontWeight: FontWeight.bold),
                            VSpace(Sizes.s3),
                            TextWidgetCommon(
                              text:
                                  'Status: ${trip.tripStatus.toDisplayString()}',
                              color: appColor(context).appTheme.white,
                              fontWeight: FontWeight.w500,
                              fontSize: Sizes.s10,
                            ),
                            VSpace(Sizes.s4),
                            TextWidgetCommon(
                                text:
                                    'Distance: ${trip.totalDistance.toStringAsFixed(1)} km',
                                color: appColor(context).appTheme.white,
                                fontWeight: FontWeight.w500,
                                fontSize: Sizes.s10),
                            VSpace(Sizes.s4),
                            TextWidgetCommon(
                              text: 'Students: $studentNames',
                              color: appColor(context).appTheme.white,
                              fontWeight: FontWeight.w500,
                              fontSize: Sizes.s10,
                            ),
                            VSpace(Sizes.s4),
                            TextWidgetCommon(
                                text: 'ETA: $formattedEta',
                                color: appColor(context).appTheme.white,
                                fontWeight: FontWeight.w500,
                                fontSize: Sizes.s10),
                          ]),
                      Container(
                        decoration: BoxDecoration(
                          color: appColor(context)
                              .appTheme
                              .white
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(Sizes.s6),
                        ),
                        child: TextWidgetCommon(
                                text:
                                    '${trip.students.length} Students Onboard',
                                color: appColor(context).appTheme.white,
                                fontWeight: FontWeight.w600,
                                fontSize: Sizes.s10)
                            .paddingSymmetric(
                          horizontal: Sizes.s8,
                          vertical: Sizes.s4,
                        ),
                      )
                    ]))));
  }
}
