import '../../../config.dart';
import 'tracking_map_widget.dart';

class AcceptRideScreen extends StatelessWidget {
  const AcceptRideScreen({super.key});

  Future<void> _initializeScreen(
    AcceptRideProvider acceptCtrl,
    SelectRiderProvider rideCtrl,
    TripTrackingProvider tripTrackingCtrl,
    HomeScreenProvider homeCtrl,
  ) async {
    rideCtrl.onInit();
    tripTrackingCtrl.init();

    await acceptCtrl.loadCurrentUserId();

    if (acceptCtrl.currentTrip == null) {
      final trips = homeCtrl.trackingData?.data ?? [];
      acceptCtrl.setCurrentTripFromList(trips);
    }

    final activeTrip = acceptCtrl.currentTrip;
    if (activeTrip?.id != null) {
      tripTrackingCtrl.unsubscribeFromCurrentTrip();
      await tripTrackingCtrl.subscribeToTrip(activeTrip!.id!);
      await acceptCtrl.fetchTripQrOtp(activeTrip.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer5<AcceptRideProvider, CancelRideProvider,
            SelectRiderProvider, TripTrackingProvider, HomeScreenProvider>(
        builder: (context1, acceptCtrl, cancelCtrl, rideCtrl, tripTrackingCtrl,
            homeCtrl, child) {
      return StatefulWrapper(
          onInit: () => _initializeScreen(
                acceptCtrl,
                rideCtrl,
                tripTrackingCtrl,
                homeCtrl,
              ),
          onDispose: () {
            tripTrackingCtrl.unsubscribeFromCurrentTrip();
            acceptCtrl.currentTrip = null;
            acceptCtrl.currentParentWaypoint = null;
          },
          child: Scaffold(body: Consumer<AcceptRideProvider>(
            builder: (context, acceptCtrlWatch, _) {
              final activeTrip = acceptCtrlWatch.currentTrip;
              final parentWaypoint = acceptCtrlWatch.currentParentWaypoint;

              return Stack(children: [
                TrackingMapWidget(
                    trip: activeTrip, parentWaypoint: parentWaypoint),

                // Back button only — no cancel ride text
                SafeArea(
                  child: GestureDetector(
                      onTap: () => route.pop(context),
                      child: Container(
                              height: Sizes.s40,
                              width: Sizes.s40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: appColor(context).appTheme.white),
                              child: SvgPicture.asset(svgAssets.back,
                                  width: Sizes.s22,
                                  height: Sizes.s22,
                                  fit: BoxFit.scaleDown))
                          .paddingDirectional(
                              horizontal: Sizes.s20, vertical: Sizes.s20)),
                ),

                // Bottom panel
                Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Emergency button aligned right above panel
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                                  padding: EdgeInsets.all(Sizes.s8),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: appColor(context).appTheme.white),
                                  child: SvgPicture.asset(
                                      svgAssets.shieldSecurity))
                              .inkWell(
                                  onTap: () =>
                                      acceptCtrl.emergencyLayout(context))
                              .paddingDirectional(
                                  bottom: Sizes.s12,
                                  horizontal: Sizes.s20)),

                      // White bottom card
                      Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.65),
                          decoration: BoxDecoration(
                              color: appColor(context).appTheme.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Sizes.s20),
                                  topRight: Radius.circular(Sizes.s20))),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Drag handle — centered, tappable, with space
                                GestureDetector(
                                    onTap: () => acceptCtrlWatch.dragOnTap(),
                                    child: Container(
                                        color: Colors.transparent,
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                            top: Sizes.s12, bottom: Sizes.s8),
                                        child: SvgPicture.asset(
                                                acceptCtrlWatch.isDrag
                                                    ? svgAssets.downDrag
                                                    : svgAssets.upDrag)
                                            .center())),

                                // Scrollable content
                                Flexible(
                                    child: SingleChildScrollView(
                                        physics:
                                            const BouncingScrollPhysics(),
                                        child: Column(children: [
                                          TextWidgetCommon(
                                              text: "Your ride",
                                              fontWeight: FontWeight.w600,
                                              fontSize: Sizes.s16),
                                          Divider(
                                                  color: appColor(context)
                                                      .appTheme
                                                      .stroke,
                                                  height: 0)
                                              .paddingDirectional(
                                                  vertical: Sizes.s16),
                                          if (acceptCtrlWatch.isDrag)
                                            AcceptRideWidgets().studentsInRide(
                                                trip: activeTrip,
                                                waypoints: activeTrip
                                                    ?.optimizedRouteData
                                                    ?.waypoints,
                                                parentWaypoint: parentWaypoint),
                                          AcceptRideWidgets().driverDetailsAndOtp(
                                              driver: activeTrip?.driver,
                                              tripType: activeTrip?.tripType,
                                              waypoints: activeTrip
                                                  ?.optimizedRouteData
                                                  ?.waypoints)
                                        ]).paddingDirectional(
                                            horizontal: Sizes.s20,
                                            bottom: Sizes.s20)))
                              ]))
                    ])
              ]);
            },
          )));
    });
  }
}
