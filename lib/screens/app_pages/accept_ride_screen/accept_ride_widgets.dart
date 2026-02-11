import 'package:taxify_user_ui/api/models/trip_tracking_response.dart';
import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/api/models/driver_response.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/user_provider.dart';
import 'package:taxify_user_ui/helper/date_formatter_helper.dart';

class AcceptRideWidgets {
  driverDetailsAndOtp({Driver? driver, List<Waypoint>? waypoints}) =>
      Consumer2<AcceptRideProvider, UserProvider>(
          builder: (context, acceptCtrl, userProvider, child) {
        final parentWaypoint = waypoints?.firstWhere(
          (w) =>
              w.parentPhoneNumber == userProvider.userData?.user?.phoneNumber,
          orElse: () => waypoints!.first,
        );
        return StatefulWrapper(
            onInit: () {},
            child: Column(children: [
              Row(children: [
                driver?.photoUrl != null
                    ? ClipOval(
                        child: Image.network(
                          driver!.photoUrl!,
                          height: Sizes.s46,
                          width: Sizes.s46,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(imageAssets.profileImg,
                                  height: Sizes.s46, width: Sizes.s46),
                        ),
                      )
                    : Image.asset(
                        imageAssets.profileImg,
                        height: Sizes.s46,
                        width: Sizes.s46,
                      ),
                HSpace(Sizes.s8),
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              TextWidgetCommon(text: driver?.name),
                              HSpace(Sizes.s4),
                              SvgPicture.asset(svgAssets.infoCircle).inkWell(
                                  onTap: () => route.pushNamed(
                                      context, routeName.driverDetailScreen))
                            ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    SvgPicture.asset(svgAssets.star),
                                    HSpace(Sizes.s6),
                                    TextWidgetCommon(text: '${driver?.rating}'),
                                    TextWidgetCommon(
                                        text: '(${driver?.totalTrips})',
                                        color: appColor(context)
                                            .appTheme
                                            .lightText)
                                  ])
                                ])
                          ]),
                      Row(children: [
                        // TODO: Add chat functionalityR
                        // Container(
                        //         height: Sizes.s34,
                        //         width: Sizes.s34,
                        //         decoration: BoxDecoration(
                        //             color: appColor(context).appTheme.bgBox,
                        //             shape: BoxShape.circle),
                        //         child: SvgPicture.asset(svgAssets.messagesDark)
                        //             .paddingDirectional(all: Sizes.s7))
                        //     .inkWell(
                        //         onTap: () => route.pushNamed(
                        //             context, routeName.chatScreen)),
                        // HSpace(Sizes.s10),
                        Container(
                                height: Sizes.s34,
                                width: Sizes.s34,
                                decoration: BoxDecoration(
                                    color: appColor(context).appTheme.bgBox,
                                    shape: BoxShape.circle),
                                child: SvgPicture.asset(svgAssets.call)
                                    .paddingDirectional(all: Sizes.s7))
                            .inkWell(
                                onTap: () => acceptCtrl.call(
                                    {'title': 'Call Driver'}, context,
                                    phoneNumber: driver?.user?.phoneNumber))
                      ])
                    ]))
              ]),
              VSpace(Sizes.s15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(children: [
                            TextWidgetCommon(
                                text: driver?.vehicleNumber,
                                fontSize: Sizes.s18,
                                fontWeight: FontWeight.w600),
                            HSpace(Sizes.s6),
                            SvgPicture.asset(svgAssets.car, height: Insets.i17)
                          ]),
                          VSpace(Sizes.s4),
                          TextWidgetCommon(
                              text: driver?.vehicleType.toDisplayString(),
                              fontWeight: FontWeight.w400,
                              fontSize: Sizes.s14)
                        ]),
                    Column(children: [
                      Builder(builder: (context) {
                        final otpCode = acceptCtrl.qrOtpData?.otpCode;
                        if (acceptCtrl.isLoadingQrOtp) {
                          return const SizedBox(
                            height: 18,
                            width: 100,
                            child: Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                          );
                        }

                        if (otpCode == null || otpCode.isEmpty) {
                          return const TextWidgetCommon(text: "----");
                        }

                        return Row(children: [
                          ...List.generate(
                            otpCode.length,
                            (index) => Row(children: [
                              commonOTPContainer(context, otpCode[index]),
                              if (index < otpCode.length - 1) HSpace(Sizes.s4),
                            ]),
                          ),
                        ]);
                      }),
                      VSpace(Sizes.s4),
                      const TextWidgetCommon(
                          text: "Start Ride PIN", fontWeight: FontWeight.w400)
                    ])
                  ]),
              Divider(height: 0, color: appColor(context).appTheme.stroke)
                  .paddingDirectional(vertical: Sizes.s20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  SvgPicture.asset(svgAssets.locationSearch),
                  HSpace(Sizes.s6),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidgetCommon(text: parentWaypoint?.address ?? ""),
                        TextWidgetCommon(
                            text:
                                "${DateFormatterHelper.formatTo12HourTime(parentWaypoint?.estimatedArrivalTime) ?? ''} · ${driver?.tripType?.toDisplayString() ?? ''}",
                            color: appColor(context).appTheme.lightText,
                            fontWeight: FontWeight.w300,
                            fontSize: Sizes.s12)
                      ]),
                ]),
              ])
                  .paddingDirectional(
                      vertical: Sizes.s12, horizontal: Sizes.s15)
                  .decorated(
                      color: appColor(context).appTheme.bgBox,
                      allRadius: Sizes.s6),
            ]));
      });

  Widget commonOTPContainer(context, String? text) {
    return Container(
        height: Sizes.s18,
        width: Sizes.s18,
        decoration: BoxDecoration(
            color: appColor(context).appTheme.yellowIcon,
            shape: BoxShape.circle),
        child: TextWidgetCommon(text: text).center());
  }
}
