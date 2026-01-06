import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taxify_user_ui/config.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptRideProvider extends ChangeNotifier {
  dynamic data;
  dynamic index;
  dynamic image;
  dynamic carName;
  dynamic driverProfile;
  dynamic driverName;
  dynamic rating;
  dynamic userRatingNumber;
  dynamic status;
  dynamic date;
  dynamic time;
  dynamic code;
  dynamic value;
  bool isDrag = false;
  List emergencyList = [];
  bool isRetry = false;

  bool isPayment = false;

  onInit() {
    emergencyList = appArray.emergencyList;
    notifyListeners();
  }

  call(e, context) async {
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
        final Uri phoneUri = Uri(scheme: 'tel', path: "987");

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

  getArgument(context) {
    data = ModalRoute.of(context)!.settings.arguments;
    log("value::value:${data}");
    index = data["index"];
    value = data["data"];
    driverProfile = value['image'];
    driverName = value['driverName'];
    rating = value['rating'];
    userRatingNumber = value['userRating'];
    status = value['status'];
    date = value['date'];
    time = value['time'];
    code = value['code'];
    carName = value['fullCarName'];
    log("message::$carName");

    notifyListeners();
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
