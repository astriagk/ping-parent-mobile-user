import 'package:taxify_user_ui/config.dart';

class ChoosePackageListLayout extends StatelessWidget {
  const ChoosePackageListLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RentalProvider>(builder: (context, rentalCtrl, child) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            ...rentalCtrl.packageList.asMap().entries.map((e) => Row(children: [
                  GestureDetector(
                      onTap: () => rentalCtrl.packageListOnTap(e.key),
                      child: Column(children: [
                        TextWidgetCommon(
                            text: e.value['hour'],
                            fontSize: Sizes.s16,
                            fontWeight: FontWeight.w500),
                        TextWidgetCommon(
                            text: e.value['km'],
                            fontSize: Sizes.s12,
                            color: appColor(context).appTheme.lightText)
                      ])
                          .paddingDirectional(
                              vertical: Sizes.s15, horizontal: Sizes.s14)
                          .decorated(
                              sideColor: rentalCtrl.hourSelectedIndex == e.key
                                  ? appColor(context).appTheme.primary
                                  : appColor(context).appTheme.trans,
                              allRadius: Sizes.s6,
                              color: rentalCtrl.hourSelectedIndex != null
                                  ? appColor(context).appTheme.white
                                  : appColor(context).appTheme.bgBox)
                          .padding(vertical: Sizes.s1, horizontal: Sizes.s1)),
                  HSpace(Sizes.s12)
                ]))
          ]));
    });
  }
}
