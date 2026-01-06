import 'package:taxify_user_ui/config.dart';

class CancelRideProvider extends ChangeNotifier {
  List cancelRide = [];
  List whyCancelList = [];
  double containerWidth = 0;

  onInit() {
    cancelRide = appArray.cancelRide;
    whyCancelList = appArray.whyCancelList;
    containerWidth = 100; // Change the width to 100

    notifyListeners();
  }

  acceptOnTap(context, e, a) {
    if (context.mounted) {
      route.pushNamed(context, routeName.acceptRideScreen,
          arg: {"index": e, "data": a});
    }
    notifyListeners();
  }

  double progress = 0.0;

  updateProgress(value) {
    progress = value;
    notifyListeners();
  }

  cancelRideQuestion(context) {
    showModalBottomSheet(
        useRootNavigator: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.8,
            snap: true,
            expand: false,
            builder: (context, scrollController) {
              return Column(children: [
                TextWidgetCommon(
                        text: "Why do you want to cancel?",
                        fontSize: Sizes.s18,
                        fontWeight: FontWeight.w600)
                    .paddingDirectional(top: Sizes.s25, bottom: Sizes.s30),
                ...whyCancelList.map((e) => IntrinsicHeight(
                        child: Row(children: [
                      SvgPicture.asset(e['svg']),
                      VerticalDivider(
                              color: appColor(context).appTheme.stroke,
                              width: 0)
                          .paddingDirectional(horizontal: Sizes.s10),
                      Expanded(child: TextWidgetCommon(text: e['question']))
                    ])
                            .inkWell(onTap: () => route.pop(context))
                            .paddingDirectional(
                                horizontal: Sizes.s12, vertical: Sizes.s12)
                            .decorated(
                                color: appColor(context).appTheme.bgBox,
                                allRadius: Sizes.s6)
                            .paddingDirectional(
                                bottom: Sizes.s12, horizontal: Sizes.s20))),
                CommonButton(text: "Close", onTap: () => route.pop(context))
                    .paddingDirectional(horizontal: Sizes.s20, top: Sizes.s40)
              ]).width(MediaQuery.of(context).size.width).decorated(
                  tLRadius: Sizes.s20,
                  tRRadius: Sizes.s20,
                  color: appColor(context).appTheme.white);
            }));
  }

  dialogOnTap(context) {
    showModalBottomSheet(
        useRootNavigator: false,
        isScrollControlled: true,
        context: context,
        builder: (_) => Consumer(builder: (context, cancelCtrl, child) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidgetCommon(
                            textAlign: TextAlign.center,
                            text: "Are you sure you want to cancel ?",
                            fontSize: Sizes.s18,
                            fontWeight: FontWeight.w600)
                        .paddingDirectional(
                            horizontal: Sizes.s55, vertical: Sizes.s30),
                    CommonButton(text: "No", onTap: () => route.pop(context)),
                    CommonButton(
                            onTap: () {
                              route.pop(context);
                              cancelRideQuestion(context);
                            },
                            text: "Yes, Cancel",
                            bgColor: appColor(context).appTheme.bgBox,
                            textColor: appColor(context).appTheme.primary)
                        .paddingDirectional(top: Sizes.s12, bottom: Sizes.s20)
                  ]).paddingDirectional(horizontal: Sizes.s20);
            }));
  }
}
