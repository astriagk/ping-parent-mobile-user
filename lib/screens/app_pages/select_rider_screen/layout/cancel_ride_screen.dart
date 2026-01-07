import 'package:taxify_user_ui/config.dart';

class CancelRideScreen {
  cancel(context) {
    showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: false,
        barrierColor:
            appColor(context).appTheme.primary.withValues(alpha: 0.60),
        transitionDuration: const Duration(milliseconds: 700),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return _CancelRideDialogContent();
        });
  }
}

class _CancelRideDialogContent extends StatefulWidget {
  @override
  State<_CancelRideDialogContent> createState() =>
      _CancelRideDialogContentState();
}

class _CancelRideDialogContentState extends State<_CancelRideDialogContent>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..addListener(() {
            final cancelRidePvr =
                Provider.of<CancelRideProvider>(context, listen: false);
            cancelRidePvr.updateProgress(controller!.value);
          });
    controller!.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CancelRideProvider, SelectRiderProvider>(
        builder: (context1, cancelCtrl, valueCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => cancelCtrl.onInit()),
          child: Builder(builder: (context) {
            // Check if the context is still active
            if (!context1.mounted) {
              return SizedBox.shrink();
            }
            return Align(
                alignment: Alignment.topCenter,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //cancel ride dialog appBar layout
                      SelectRiderWidgets().cancelRideAppBar(context),
                      Expanded(
                          child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: cancelCtrl.cancelRide
                                      .asMap()
                                      .entries
                                      .map((e) => Column(children: [
                                            //cancel ride dialog image, CarName layout
                                            SelectRiderWidgets()
                                                .imageCarNameLayout(
                                                    e.value, context),
                                            //driver name ,time layout
                                            SelectRiderWidgets()
                                                .driverNameTimeLayout(
                                                    e.value, context),
                                            //rating , userRating ,km layout
                                            SelectRiderWidgets()
                                                .ratingUserRatingKmLayout(
                                                    e.value, context),
                                            //skip and accept Button layout
                                            SelectRiderWidgets()
                                                .skipAndAcceptButton(context,
                                                    skip: () {
                                              cancelCtrl.cancelRide
                                                  .removeAt(e.key);
                                              if (cancelCtrl
                                                  .cancelRide.isEmpty) {
                                                Navigator.pop(context);
                                              } else {
                                                // Trigger UI rebuild
                                                (context as Element)
                                                    .markNeedsBuild();
                                              }
                                            }, accept: () {
                                              // Check if the context is still active
                                              if (context1.mounted) {
                                                cancelCtrl.acceptOnTap(
                                                    context, e.key, e.value);
                                              }
                                            }),
                                            //animated timing layout
                                            SelectRiderWidgets()
                                                .animatedTimingLayout(context)
                                          ]).cancelMainListExtension(context))
                                      .toList())
                              .paddingDirectional(all: Sizes.s20))
                    ]));
          }));
    });
  }
}
