import '../../../config.dart';

class AppSettingScreenWidget {
  /*settingCurrencyLayout(context) {
    return showModalBottomSheet(
      useRootNavigator: false,
      isScrollControlled: true,
      context: context,
      builder: (_) => DraggableScrollableSheet(
          expand: false,initialChildSize: 0.53,
          builder: (_, controller) =>
              Consumer<SettingProvider>(builder: (context, settingCtrl, child) {
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            TextWidgetCommon(
                                text: appFonts.changeCurrency,
                                fontSize: Sizes.s18,
                                fontWeight: FontWeight.w500),
                            SvgPicture.asset(svgAssets.close).inkWell(onTap: () => route.pop(context))
                          ]),
                          VSpace(Sizes.s20),
                          ...settingCtrl.currencyList.asMap().entries.map((e) =>
                              Column(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        SvgPicture.asset(e.value['flag']),
                                        HSpace(Sizes.s20),
                                        TextWidgetCommon(text: e.value['title'])
                                      ]),
                                      InkWell(radius: 0,
                                          onTap: () =>
                                              settingCtrl.onChangeButton(e.key),
                                          child: settingCtrl.selectIndex == e.key
                                              ? Container(
                                                  width: Sizes.s20,
                                                  height: Sizes.s20,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: appColor(context)
                                                          .appTheme
                                                          .primary
                                                          .withValues(alpha:0.12)),
                                                  child: Icon(Icons.circle,
                                                      color: appColor(context)
                                                          .appTheme
                                                          .primary,
                                                      size: Sizes.s13))
                                              : Container(
                                                  width: Sizes.s20,
                                                  height: Sizes.s20,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color:
                                                              appColor(context)
                                                                  .appTheme
                                                                  .stroke))))
                                    ]).padding(vertical: Sizes.s15),
                                if (e.key != e.value['title'].length - 1)
                                  Divider(
                                    color: appColor(context).appTheme.stroke,
                                  )
                              ])),

                          CommonButton(text: appFonts.update).padding(top: Sizes.s30)
                        ])).paddingDirectional(all: Sizes.s20);
              })),
    );
  }*/
  Widget customRadioContainer({GestureTapCallback? onTap, e}) {
    return Consumer<SettingProvider>(builder: (context, settingCtrl, child) {
      return InkWell(
          radius: 0,
          onTap: () => onTap,
          child: settingCtrl.selectIndex == e.key
              ? Container(
                  width: Sizes.s20,
                  height: Sizes.s20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColor(context)
                          .appTheme
                          .primary
                          .withValues(alpha: 0.12)),
                  child: Icon(Icons.circle,
                      color: appColor(context).appTheme.primary,
                      size: Sizes.s13))
              : Container(
                  width: Sizes.s20,
                  height: Sizes.s20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: appColor(context).appTheme.stroke))));
    });
  }
}
