import '../../../../../config.dart';

class LocationWidgets {
  //common title and text-field layout
  Widget commonTextFields(context,
      {String? title,
      String? hintText,
      String? icon,
      TextEditingController? controller,
      bool? prefixIcon}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
          text: title,
          style: AppCss.lexendMedium14
              .textColor(appColor(context).appTheme.darkText)),
      TextFieldCommon(
              controller: controller,
              hintText: hintText,
              prefixIcon: prefixIcon != true
                  ? SvgPicture.asset("$icon", fit: BoxFit.scaleDown)
                  : const SizedBox.shrink())
          .padding(top: Sizes.s8, bottom: Sizes.s20)
    ]);
  }

  //title and back button layout
  Widget selectAppBarLayout(context) {
    return Row(children: [
      HSpace(Sizes.s20),
      CommonIconButton(icon: svgAssets.back, onTap: () => route.pop(context))
          .backButtonBorderExtension(context),
      HSpace(Sizes.s50),
      TextWidgetCommon(
          text: appFonts.addNewLocation,
          style: AppCss.lexendMedium18
              .textColor(appColor(context).appTheme.darkText))
    ]);
  }

  //current position Icon layout
  Widget currentPositionIcon(context) {
    return Consumer<AddLocationProvider>(
        builder: (context, locationCtrl, child) {
      return Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
              height: Sizes.s40,
              width: Sizes.s40,
              child: SvgPicture.asset(svgAssets.current, fit: BoxFit.scaleDown)
                  .decorated(
                      allRadius: Sizes.s8,
                      color: appColor(context).appTheme.white)
                  .inkWell(
                      onTap: () => locationCtrl.currentLocation()))).padding(
          bottom: Sizes.s20, horizontal: Sizes.s20);
    });
  }
}
