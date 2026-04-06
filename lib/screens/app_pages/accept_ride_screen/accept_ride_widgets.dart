import 'package:skolo/api/enums/trip_type.dart';
import 'package:skolo/api/models/trip_tracking_response.dart';
import 'package:skolo/config.dart';
import 'package:skolo/api/models/driver_response.dart';
import 'package:skolo/provider/app_pages_providers/user_provider.dart';
import 'package:skolo/helper/date_formatter_helper.dart';

class AcceptRideWidgets {
  driverDetailsAndOtp(
          {Driver? driver,
          List<Waypoint>? waypoints,
          TripType? tripType}) =>
      Consumer2<AcceptRideProvider, UserProvider>(
          builder: (context, acceptCtrl, userProvider, child) {
        final parentWaypoint = waypoints?.firstWhere(
          (w) =>
              w.parentPhoneNumber == userProvider.userData?.user?.phoneNumber,
          orElse: () => waypoints!.first,
        );
        final isDrop = tripType == TripType.drop;
        return StatefulWrapper(
            onInit: () {},
            child: Column(children: [
              // Driver info row
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                // Avatar (no border/ring)
                ClipOval(
                  child: driver?.photoUrl != null
                      ? Image.network(
                          driver!.photoUrl!,
                          height: Sizes.s46,
                          width: Sizes.s46,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(imageAssets.profileImg,
                                  height: Sizes.s46,
                                  width: Sizes.s46,
                                  fit: BoxFit.cover),
                        )
                      : Image.asset(imageAssets.profileImg,
                          height: Sizes.s46, width: Sizes.s46),
                ),
                HSpace(Sizes.s12),
                // Name + info icon
                Expanded(
                    child: Row(children: [
                  Flexible(
                      child: TextWidgetCommon(
                          text: driver?.name ?? '—',
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.s15)),
                  HSpace(Sizes.s6),
                  SvgPicture.asset(svgAssets.infoCircle, height: Sizes.s14)
                      .inkWell(
                          onTap: () => route.pushNamed(
                              context, routeName.driverDetailScreen))
                ])),
                // Call button
                Container(
                        height: Sizes.s38,
                        width: Sizes.s38,
                        decoration: BoxDecoration(
                            color: appColor(context).appTheme.bgBox,
                            shape: BoxShape.circle),
                        child: SvgPicture.asset(svgAssets.call)
                            .paddingDirectional(all: Sizes.s9))
                    .inkWell(
                        onTap: () => acceptCtrl.call(
                            {'title': 'Call Driver'}, context,
                            phoneNumber: driver?.user?.phoneNumber))
              ]),

              VSpace(Sizes.s16),

              // Vehicle + OTP row
              Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes.s14, vertical: Sizes.s12),
                  decoration: BoxDecoration(
                      color: appColor(context).appTheme.bgBox,
                      borderRadius: BorderRadius.circular(Sizes.s12)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Vehicle info
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                SvgPicture.asset(svgAssets.car,
                                    height: Sizes.s14),
                                HSpace(Sizes.s6),
                                TextWidgetCommon(
                                    text: driver?.vehicleType
                                            .toDisplayString() ??
                                        '—',
                                    fontSize: Sizes.s12,
                                    color: appColor(context).appTheme.lightText)
                              ]),
                              VSpace(Sizes.s6),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Sizes.s10,
                                      vertical: Sizes.s4),
                                  decoration: BoxDecoration(
                                      color: appColor(context).appTheme.white,
                                      borderRadius:
                                          BorderRadius.circular(Sizes.s6),
                                      border: Border.all(
                                          color: appColor(context)
                                              .appTheme
                                              .stroke)),
                                  child: TextWidgetCommon(
                                      text: driver?.vehicleNumber ?? '—',
                                      fontSize: Sizes.s14,
                                      fontWeight: FontWeight.w700))
                            ]),

                        // Vertical divider
                        Container(
                            height: Sizes.s40,
                            width: Sizes.s1,
                            color: appColor(context).appTheme.stroke),

                        // OTP section
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Builder(builder: (context) {
                                final otpCode = acceptCtrl.qrOtpData?.otpCode;
                                if (acceptCtrl.isLoadingQrOtp) {
                                  return SizedBox(
                                      height: Sizes.s24,
                                      width: Sizes.s80,
                                      child: const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2)));
                                }
                                if (otpCode == null || otpCode.isEmpty) {
                                  return TextWidgetCommon(
                                      text: "----",
                                      fontSize: Sizes.s20,
                                      fontWeight: FontWeight.w700);
                                }
                                return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                        otpCode.length,
                                        (index) => Row(children: [
                                              commonOTPContainer(
                                                  context, otpCode[index]),
                                              if (index < otpCode.length - 1)
                                                HSpace(Sizes.s5),
                                            ])));
                              }),
                              VSpace(Sizes.s6),
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                SvgPicture.asset(svgAssets.shieldSecurity,
                                    height: Sizes.s10,
                                    colorFilter: ColorFilter.mode(
                                        appColor(context).appTheme.lightText,
                                        BlendMode.srcIn)),
                                HSpace(Sizes.s4),
                                TextWidgetCommon(
                                    text: "Start Ride PIN",
                                    fontSize: Sizes.s11,
                                    fontWeight: FontWeight.w400,
                                    color: appColor(context).appTheme.lightText)
                              ])
                            ])
                      ])),

              VSpace(Sizes.s12),

              // Pickup location card
              Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes.s14, vertical: Sizes.s12),
                  decoration: BoxDecoration(
                      color: appColor(context).appTheme.bgBox,
                      borderRadius: BorderRadius.circular(Sizes.s12)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Address row
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: Sizes.s2),
                                  child: SvgPicture.asset(
                                      svgAssets.locationSearch,
                                      height: Sizes.s16)),
                              HSpace(Sizes.s10),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    TextWidgetCommon(
                                        text: isDrop ? "Your Drop" : "Your Pickup",
                                        fontSize: Sizes.s11,
                                        fontWeight: FontWeight.w400,
                                        color: appColor(context)
                                            .appTheme
                                            .lightText),
                                    VSpace(Sizes.s2),
                                    TextWidgetCommon(
                                        text: parentWaypoint?.address ?? "—",
                                        fontSize: Sizes.s13,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis),
                                  ]))
                            ]),

                        // Divider
                        Divider(
                                height: 0,
                                color: appColor(context).appTheme.stroke)
                            .paddingDirectional(vertical: Sizes.s10),

                        // Pickup time + trip type badge
                        Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                SvgPicture.asset(svgAssets.clock,
                                    height: Sizes.s14,
                                    colorFilter: ColorFilter.mode(
                                        appColor(context).appTheme.primary,
                                        BlendMode.srcIn)),
                                HSpace(Sizes.s6),
                                TextWidgetCommon(
                                    text: isDrop ? "Drop at" : "Pickup at",
                                    fontSize: Sizes.s12,
                                    fontWeight: FontWeight.w400,
                                    color: appColor(context)
                                        .appTheme
                                        .lightText),
                                HSpace(Sizes.s4),
                                TextWidgetCommon(
                                    text: DateFormatterHelper
                                            .formatTo12HourTime(
                                                parentWaypoint
                                                    ?.estimatedArrivalTime) ??
                                        '—',
                                    fontSize: Sizes.s12,
                                    fontWeight: FontWeight.w600),
                              ]),

                              // Trip type badge
                              if (tripType != null)
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Sizes.s8,
                                        vertical: Sizes.s3),
                                    decoration: BoxDecoration(
                                        color: appColor(context)
                                            .appTheme
                                            .primary
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(Sizes.s20)),
                                    child: TextWidgetCommon(
                                        text: tripType.toDisplayString(),
                                        fontSize: Sizes.s11,
                                        fontWeight: FontWeight.w500,
                                        color: appColor(context)
                                            .appTheme
                                            .primary))
                            ])
                      ]))
            ]));
      });

  Widget studentsInRide(
          {Trip? trip,
          List<Waypoint>? waypoints,
          Waypoint? parentWaypoint}) =>
      Builder(builder: (context) {
        final studentIds = parentWaypoint?.studentIds ?? [];
        final photoUrl = parentWaypoint?.studentPhotoUrl;

        final matchedStudents = (trip?.students ?? [])
            .where((s) => studentIds.contains(s.studentId))
            .toList();

        if (matchedStudents.isEmpty) return const SizedBox.shrink();

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextWidgetCommon(
              text: "Students in this ride",
              fontSize: Sizes.s13,
              fontWeight: FontWeight.w500,
              color: appColor(context).appTheme.lightText),
          VSpace(Sizes.s10),
          ...matchedStudents.map((student) {
            // Use waypoint photo only when there's exactly one student
            final showPhoto =
                photoUrl != null && matchedStudents.length == 1;

            return Container(
              margin: EdgeInsets.only(bottom: Sizes.s8),
              padding: EdgeInsets.symmetric(
                  horizontal: Sizes.s14, vertical: Sizes.s10),
              decoration: BoxDecoration(
                  color: appColor(context).appTheme.bgBox,
                  borderRadius: BorderRadius.circular(Sizes.s12)),
              child: Row(children: [
                // Avatar: photo or initials
                ClipOval(
                  child: showPhoto
                      ? Image.network(
                          photoUrl,
                          height: Sizes.s40,
                          width: Sizes.s40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _initialsAvatar(context, student.studentName),
                        )
                      : _initialsAvatar(context, student.studentName),
                ),
                HSpace(Sizes.s12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      TextWidgetCommon(
                          text: student.studentName ?? '—',
                          fontSize: Sizes.s14,
                          fontWeight: FontWeight.w600),
                      VSpace(Sizes.s3),
                      TextWidgetCommon(
                          text:
                              'Class ${student.class_ ?? '—'} · Section ${student.section ?? '—'}',
                          fontSize: Sizes.s12,
                          fontWeight: FontWeight.w400,
                          color: appColor(context).appTheme.lightText)
                    ]))
              ]),
            );
          }),
          VSpace(Sizes.s4),
        ]);
      });

  Widget _initialsAvatar(BuildContext context, String? name) {
    String initials;
    if (name == null || name.trim().isEmpty) {
      initials = '?';
    } else {
      final parts = name.trim().split(' ');
      initials = parts.length == 1
          ? parts[0][0].toUpperCase()
          : '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return Container(
        height: Sizes.s40,
        width: Sizes.s40,
        color: appColor(context).appTheme.yellowIcon,
        child: TextWidgetCommon(
                text: initials,
                fontSize: Sizes.s14,
                fontWeight: FontWeight.w600,
                color: appColor(context).appTheme.white)
            .center());
  }

  Widget commonOTPContainer(context, String? text) {
    return Container(
        height: Sizes.s26,
        width: Sizes.s26,
        decoration: BoxDecoration(
            color: appColor(context).appTheme.yellowIcon,
            borderRadius: BorderRadius.circular(Sizes.s6)),
        child: TextWidgetCommon(
                text: text,
                fontWeight: FontWeight.w700,
                fontSize: Sizes.s13,
                color: appColor(context).appTheme.white)
            .center());
  }
}
