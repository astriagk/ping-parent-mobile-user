import '../../../config.dart';
import 'tracking_map_widget.dart';

class AcceptRideScreen extends StatelessWidget {
  const AcceptRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<AcceptRideProvider, CancelRideProvider,
            SelectRiderProvider, TripTrackingProvider>(
        builder: (context1, acceptCtrl, cancelCtrl, rideCtrl, tripTrackingCtrl,
            child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150).then((value) {
                acceptCtrl.getArgument(context);
                rideCtrl.onInit();

                // Initialize trip tracking and subscribe to WebSocket events
                tripTrackingCtrl.init();
              }),
          child: Scaffold(
              body: Stack(children: [
            const TrackingMapWidget(),
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
                                    color: appColor(context).appTheme.white),
                                child:
                                    SvgPicture.asset(svgAssets.shieldSecurity))
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
                      AcceptRideWidgets().driverDetailsAndOtp()
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
          ])));
    });
  }
}
