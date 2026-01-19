import '../../../../../config.dart';

class StreetAddressLayout extends StatelessWidget {
  const StreetAddressLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddLocationProvider>(
        builder: (context, locationCtrl, child) {
      print("address===>${locationCtrl.formattedAddress}");
      return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
                  decoration: ShapeDecoration(
                      color: appColor(context).appTheme.white,
                      shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.only(
                              topLeft: SmoothRadius(
                                  cornerRadius: Sizes.s20, cornerSmoothing: 1),
                              topRight: SmoothRadius(
                                  cornerRadius: Sizes.s20,
                                  cornerSmoothing: 1)))),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          SvgPicture.asset(svgAssets.locationPin),
                          HSpace(Sizes.s10),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                TextWidgetCommon(
                                    text: locationCtrl.formattedAddress,
                                    textAlign: TextAlign.start,
                                    style: AppCss.lexendSemiBold14
                                        .textColor(
                                            appColor(context).appTheme.darkText)
                                        .textHeight(1.2)),
                              ]))
                        ])
                        .padding(vertical: Sizes.s20, horizontal: Sizes.s20)
                        .decorated(
                            color: appColor(context).appTheme.bgBox,
                            allRadius: Sizes.s8)
                        .padding(top: Sizes.s20),
                    CommonButton(
                            onTap: () => route.pushNamed(
                                context, routeName.addNewLocationScreen),
                            text: appFonts.confirmLocation)
                        .padding(vertical: Sizes.s20)
                  ]).padding(horizontal: Sizes.s20))
              .backgroundColor(appColor(context).appTheme.darkText));
    });
  }
}
