import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taxify_user_ui/config.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/api_client.dart';
import '../../api/services/accept_ride_service.dart';
import '../../api/services/storage_service.dart';
import '../../api/models/qr_otp_response.dart';
import '../../api/models/trip_tracking_response.dart';

class AcceptRideProvider extends ChangeNotifier {
  bool isDrag = false;
  List emergencyList = [];
  bool isRetry = true;

  bool isPayment = false;

  // QR/OTP related state
  final AcceptRideService _acceptRideService = AcceptRideService(ApiClient());
  final StorageService _storageService = StorageService();
  QrOtpData? qrOtpData;
  bool isLoadingQrOtp = false;
  String? qrOtpError;

  // Current user ID from storage
  String? currentUserId;

  // Current matching trip and parent waypoint
  Trip? currentTrip;
  Waypoint? currentParentWaypoint;

  AcceptRideProvider();

  onInit() {
    emergencyList = appArray.emergencyList;
    notifyListeners();
  }

  /// Load the current user ID from storage
  Future<void> loadCurrentUserId() async {
    if (currentUserId != null) return;
    currentUserId = await _storageService.getUserId();
    notifyListeners();
  }

  /// Get the trip that matches the current user's ID from waypoints
  Trip? getMatchingTrip(List<Trip> trips) {
    if (currentUserId == null || trips.isEmpty) return null;

    try {
      return trips.firstWhere(
        (trip) =>
            trip.optimizedRouteData?.waypoints.any(
              (waypoint) =>
                  waypoint.parentUserId == currentUserId &&
                  waypoint.parentName != null,
            ) ??
            false,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get parent waypoint details from the matching trip
  Waypoint? getParentWaypoint(Trip? trip) {
    if (trip == null || currentUserId == null) return null;

    try {
      return trip.optimizedRouteData?.waypoints.firstWhere(
        (waypoint) =>
            waypoint.parentUserId == currentUserId &&
            waypoint.parentName != null,
      );
    } catch (e) {
      return null;
    }
  }

  /// Set current trip and parent waypoint from trips list
  void setCurrentTripFromList(List<Trip> trips) {
    currentTrip = getMatchingTrip(trips);
    currentParentWaypoint = getParentWaypoint(currentTrip);
    notifyListeners();
  }

  /// Fetches QR code and OTP for a parent's trip
  Future<void> fetchTripQrOtp(String tripId) async {
    isLoadingQrOtp = true;
    qrOtpError = null;
    notifyListeners();

    try {
      final response = await _acceptRideService.getParentTripQrOtp(tripId);

      if (response.success && response.data != null) {
        qrOtpData = response.data;
        qrOtpError = null;
      } else {
        qrOtpError = response.error ?? 'Failed to fetch QR/OTP';
        qrOtpData = null;
      }
    } catch (e) {
      qrOtpError = 'An error occurred while fetching QR/OTP';
      qrOtpData = null;
    } finally {
      isLoadingQrOtp = false;
      notifyListeners();
    }
  }

  /// Clears QR/OTP data
  void clearQrOtpData() {
    qrOtpData = null;
    qrOtpError = null;
    isLoadingQrOtp = false;
    notifyListeners();
  }

  call(e, context, {String? phoneNumber}) async {
    log("eeee $e");
    if (e['title'] == "Share my location") {
      String text = 'Share My Location!';
      String? subject = 'Current Location';

      final box = context.findRenderObject() as RenderBox?;
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box != null
              ? box.localToGlobal(Offset.zero) & box.size
              : Rect.zero);
    } else {
      PermissionStatus status = await Permission.phone.request();

      if (status.isGranted) {
        final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

        // Try to launch the dialer
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
        } else {
          log("Could not open dialer");
        }
      } else if (status.isDenied) {
        log("Phone permission denied");
      } else if (status.isPermanentlyDenied) {
        log("Phone permission permanently denied, open app settings.");
        openAppSettings();
      }
    }
  }

  dragOnTap() {
    isDrag = !isDrag;
    notifyListeners();
  }

  emergencyLayout(context) {
    return showModalBottomSheet(
        context: context,
        useRootNavigator: false,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
            expand: false,
            snap: true,
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Consumer<AcceptRideProvider>(
                  builder: (context, acceptCtrl, child) {
                return StatefulWrapper(
                    onInit: () => acceptCtrl.onInit(),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SvgPicture.asset(svgAssets.upSmall),
                      TextWidgetCommon(
                              text: "Keep yourself safe",
                              fontSize: Sizes.s18,
                              fontWeight: FontWeight.w600)
                          .paddingDirectional(vertical: Sizes.s15),
                      Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: emergencyList
                                  .map((e) => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                            SvgPicture.asset(e['image']),
                                            VSpace(Sizes.s7),
                                            TextWidgetCommon(
                                                    text: e['title'],
                                                    textAlign: TextAlign.center,
                                                    fontWeight: FontWeight.w400)
                                                .paddingDirectional(
                                                    horizontal: Sizes.s10)
                                          ])
                                          .inkWell(
                                              onTap: () => call(e, context))
                                          .height(101)
                                          .width(Sizes.s104)
                                          .decorated(
                                              sideColor: appColor(context)
                                                  .appTheme
                                                  .stroke,
                                              color: appColor(context)
                                                  .appTheme
                                                  .bgBox,
                                              allRadius: Sizes.s10))
                                  .toList())
                          .paddingDirectional(horizontal: Sizes.s15),
                      CommonButton(
                              onTap: () => route.pop(context),
                              text: "Cancel",
                              bgColor: appColor(context).appTheme.bgBox,
                              textColor: appColor(context).appTheme.darkText)
                          .paddingDirectional(
                              top: Sizes.s30, horizontal: Sizes.s20)
                    ]).width(MediaQuery.of(context).size.width).decorated(
                        color: appColor(context).appTheme.white,
                        tRRadius: Sizes.s20,
                        tLRadius: Sizes.s20));
              });
            }));
  }
}
