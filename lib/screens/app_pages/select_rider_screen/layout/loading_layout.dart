import 'package:taxify_user_ui/config.dart';

class LoadingDriverLayout extends StatelessWidget {
  const LoadingDriverLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingScreenProvider>(
        builder: (context, loadingCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => loadingCtrl.onInit(context)),
          child: Column(children: [
            Column(children: [
              Stack(children: [
                Image.asset(gifAssets.car)
                    .marginSymmetric(horizontal: Insets.i40)
              ]),
              VSpace(Sizes.s40),
              /* SliderButton(
                      action: () async {
                        route.pop(context);
                        return true;
                      },
                      label: TextWidgetCommon(
                              text: appFonts.slideToCancel, fontSize: Sizes.s16)
                          .center()
                          .padding(left: 20),
                      icon: SvgPicture.asset(svgAssets.doubleArrowRight),
                      radius: 9,
                      buttonColor: appColor(context).appTheme.primary,
                      backgroundColor: appColor(context).appTheme.bgBox,
                      highlightedColor: Colors.white)*/
              SizedBox(
                  width: double.infinity,
                  height: Sizes.s48,
                  child: SliderButton(
                          action: () async {
                            route.pop(context);
                            return true;
                          },
                          label: TextWidgetCommon(
                                  text: appFonts.slideToCancel,
                                  fontSize: Sizes.s16)
                              .center(),
                          icon: SvgPicture.asset(svgAssets.doubleArrowRight),
                          radius: 9,
                          height: 62,
                          alignLabel: Alignment.center,
                          buttonColor: appColor(context).appTheme.primary,
                          backgroundColor: appColor(context).appTheme.bgBox,
                          highlightedColor: Colors.white)
                      .marginSymmetric(horizontal: Sizes.s20))
            ])
                .width(MediaQuery.of(context).size.width)
                .padding(top: Insets.i10, bottom: Insets.i25)
                .decorated(color: appColor(context).appTheme.white)
          ]));
    });
  }
}
