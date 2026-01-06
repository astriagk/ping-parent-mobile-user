import '../config.dart';

//common switch rider layout
class CommonSwitchRider extends StatelessWidget {
  const CommonSwitchRider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SwitchRiderProvider>(builder: (context, switchCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => switchCtrl.onInit()),
          child: Row(children: [
            SvgPicture.asset(svgAssets.profile),
            HSpace(Sizes.s2),
            TextWidgetCommon(text: appFonts.switchRider),
            HSpace(Sizes.s4),
            SvgPicture.asset(svgAssets.arrowDown)
          ])
              .padding(horizontal: Sizes.s8, vertical: Sizes.s9)
              .decorated(
                  allRadius: Sizes.s18, color: appColor(context).appTheme.white)
              .inkWell(onTap: () => switchCtrl.onTapEvent(context)));
    });
  }
}
