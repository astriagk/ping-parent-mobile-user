import '../../../../config.dart';

class SwitchRiderSheet extends StatelessWidget {
  const SwitchRiderSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SwitchRiderProvider>(builder: (context, switchCtrl, child) {
      return DraggableScrollableSheet(
          initialChildSize: 0.38,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
                decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.only(
                            topLeft: SmoothRadius(
                                cornerRadius: AppRadius.r20,
                                cornerSmoothing: 1),
                            topRight: SmoothRadius(
                                cornerRadius: AppRadius.r20,
                                cornerSmoothing: 0.4))),
                    color: appColor(context).appTheme.trans),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidgetCommon(
                          text: appFonts.someoneElseTaking,
                          fontSize: Sizes.s18,
                          fontWeight: FontWeight.w500),
                      TextWidgetCommon(
                              fontSize: Sizes.s12,
                              color: appColor(context).appTheme.lightText,
                              fontHeight: 1.5,
                              text: appFonts.chooseAContactSo)
                          .padding(top: Sizes.s6),
                      ...switchCtrl.chooseRider.asMap().entries.map((e) {
                        return ChooseRiderList(
                            e: e, chooseRider: switchCtrl.chooseRider.length);
                      }),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: CommonButton(
                                    onTap: () => route.pop(context),
                                    bgColor: appColor(context).appTheme.bgBox,
                                    textColor:
                                        appColor(context).appTheme.darkText,
                                    text: appFonts.skip)),
                            HSpace(Sizes.s15),
                            Expanded(
                                child: CommonButton(
                                    text: appFonts.done,
                                    onTap: () => route.pop(context)))
                          ])
                    ]).padding(horizontal: Sizes.s20, vertical: Insets.i20));
          });
    });
  }
}
