import '../../../../config.dart';

//vehicle type image ,time, fareAway,title layout
class VehicleTypeLayout extends StatelessWidget {
  final dynamic e;
  final Color? sideColor;
  final bool? isRental;
  final GestureTapCallback? onTap;
  final GestureTapCallback? infoOnTap;

  const VehicleTypeLayout(
      {super.key,
      this.e,
      this.sideColor,
      this.isRental,
      this.onTap,
      this.infoOnTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectRiderProvider>(builder: (context, riderCtrl, child) {
      return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SvgPicture.asset(svgAssets.infoCircle).inkWell(onTap: infoOnTap),
            Image.asset(e.value['image'], fit: BoxFit.fill)
                .center()
                .padding(vertical: Sizes.s10),
            isRental == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        TextWidgetCommon(text: e.value['title']),
                        Row(children: [
                          SvgPicture.asset(svgAssets.profileDark,
                              height: Sizes.s12,
                              width: Sizes.s12,
                              colorFilter: ColorFilter.mode(
                                  appColor(context).appTheme.lightText,
                                  BlendMode.srcIn)),
                          HSpace(Sizes.s2),
                          TextWidgetCommon(
                              text: e.value['person'],
                              fontSize: Sizes.s12,
                              color: appColor(context).appTheme.lightText)
                        ])
                      ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        TextWidgetCommon(text: e.value['title']),
                        TextWidgetCommon(
                                text: "• ${e.value['time']}",
                                fontSize: Sizes.s11,
                                fontWeight: FontWeight.w300,
                                color: appColor(context).appTheme.lightText)
                            .padding(top: Sizes.s6, bottom: Sizes.s3),
                        TextWidgetCommon(
                            text: "• ${e.value['away']}",
                            fontSize: Sizes.s11,
                            fontWeight: FontWeight.w300,
                            color: appColor(context).appTheme.lightText)
                      ])
          ])
          .width(Sizes.s104)
          .padding(all: Sizes.s12)
          .decorated(
              sideColor: sideColor,
              color: appColor(context).appTheme.white,
              allRadius: Sizes.s10)
          .inkWell(onTap: onTap)
          .padding(
              horizontal: e.key == 1 || e.key == 2 ? Sizes.s10 : Sizes.s2,
              vertical: Sizes.s2);
    });
  }
}
