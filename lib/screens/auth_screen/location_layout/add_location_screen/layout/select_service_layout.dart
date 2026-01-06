import '../../../../../config.dart';

class SelectServiceLayout extends StatelessWidget {
  const SelectServiceLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddLocationProvider>(
        builder: (context, locationCtrl, child) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            // /  padding: EdgeInsets.only(bottom: Sizes.s210),
            decoration: ShapeDecoration(
                color: appColor(context).appTheme.primary,
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                        topLeft: SmoothRadius(
                            cornerRadius: Sizes.s20, cornerSmoothing: 1),
                        topRight: SmoothRadius(
                            cornerRadius: Sizes.s20, cornerSmoothing: 1)))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidgetCommon(
                      text: appFonts.selectServiceLocation,
                      style: AppCss.lexendMedium14
                          .textColor(appColor(context).appTheme.white)),
                  TextWidgetCommon(
                          text: appFonts.change,
                          style: AppCss.lexendRegular14
                              .textColor(appColor(context).appTheme.yellowIcon)
                              .textDecoration(TextDecoration.underline,
                                  color: appColor(context).appTheme.yellowIcon))
                      .inkWell(
                          onTap: () => route.pushNamed(
                              context, routeName.addNewLocationScreen))
                ]).padding(
                horizontal: Sizes.s20, top: Sizes.s20, vertical: Sizes.s20)),
      );
    });
  }
}
