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

    // Ensure user ID is loaded before proceeding
    await acceptCtrl.loadCurrentUserId();

    // Set current trip and parent waypoint only if not already set
    // (user may have pre-selected a specific trip from the trip selection sheet)
    if (acceptCtrl.currentTrip == null) {
      final trips = homeCtrl.trackingData?.data ?? [];
      acceptCtrl.setCurrentTripFromList(trips);
    }

    // Subscribe to the current trip's websocket for real-time position updates
    final activeTrip = acceptCtrl.currentTrip;
    if (activeTrip?.tripId != null) {
      // Unsubscribe from any prior trip before subscribing to the selected one
      tripTrackingCtrl.unsubscribeFromCurrentTrip();
      // Subscribe to websocket for real-time driver position
      await tripTrackingCtrl.subscribeToTrip(activeTrip!.tripId!);
      // Fetch QR/OTP for the trip
      await acceptCtrl.fetchTripQrOtp(activeTrip.tripId!);
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

              return Stack(children: [
                TrackingMapWidget(trip: activeTrip),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectRiderWidgets().cancelRideAppBar(context),
                      Column(children: [
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                    padding: EdgeInsets.all(Sizes.s8),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            appColor(context).appTheme.white),
                                    child: SvgPicture.asset(
                                        svgAssets.shieldSecurity))
                                .inkWell(
                                    onTap: () =>
                                        acceptCtrl.emergencyLayout(context))
                                .paddingDirectional(
                                    bottom: Sizes.s25, horizontal: Sizes.s20)),
                        Column(children: [
                          SvgPicture.asset(acceptCtrl.isDrag == true
                                  ? svgAssets.downDrag
                                  : svgAssets.upDrag)
                              .inkWell(onTap: () => acceptCtrl.dragOnTap())
                              .paddingDirectional(
                                  top: acceptCtrl.isDrag == true
                                      ? Sizes.s0
                                      : Sizes.s9,
                                  bottom: Sizes.s10)
                              .center(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidgetCommon(
                                    text: "Your ride",
                                    fontWeight: FontWeight.w600,
                                    fontSize: Sizes.s16),
                                SvgPicture.asset(svgAssets.myRideAuto,
                                    height: Sizes.s25)
                              ]),
                          Divider(
                                  color: appColor(context).appTheme.stroke,
                                  height: 0)
                              .paddingDirectional(vertical: Sizes.s20),
                          AcceptRideWidgets().driverDetailsAndOtp(
                              driver: activeTrip?.driver,
                              waypoints:
                                  activeTrip?.optimizedRouteData?.waypoints)
                        ])
                            .paddingDirectional(
                                horizontal: Sizes.s20, bottom: Sizes.s20)
                            .width(MediaQuery.of(context).size.width)
                            .decorated(
                                color: appColor(context).appTheme.white,
                                tLRadius: Sizes.s20,
                                tRRadius: Sizes.s20)
                      ])
                    ])
              ]);
            },
          )));
    });
  }
}
