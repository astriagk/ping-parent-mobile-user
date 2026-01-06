import '../../../../config.dart';
import '../../../../widgets/common_confirmation_dialog.dart';

//ICON WORK OR HOME EDIT AND DELETE LAYOUT
class WorkTitleLayout extends StatelessWidget {
  final dynamic e;

  // final int index;

  const WorkTitleLayout({super.key, this.e});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SaveLocationProvider, SettingProvider>(
        builder: (context, slCtrl, settingPvr, child) {
      return IntrinsicHeight(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          CommonIconButton(icon: e['icon']),
          HSpace(Sizes.s10),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidgetCommon(
                    text: e['title'],
                    style: AppCss.lexendRegular14
                        .textColor(appColor(context).appTheme.darkText)),
                TextWidgetCommon(
                    text: "+91 25632 56931",
                    style: TextStyle(
                        color: appColor(context).appTheme.lightText,
                        fontSize: Sizes.s12,
                        fontFamily: GoogleFonts.lexend().fontFamily,
                        fontWeight: FontWeight.w300))
              ])
        ]),
        Row(children: [
          SvgPicture.asset(svgAssets.edit).inkWell(
              onTap: () =>
                  route.pushNamed(context, routeName.addLocationScreen)),
          VerticalDivider(color: appColor(context).appTheme.stroke, width: 0)
              .padding(vertical: Sizes.s8, horizontal: Sizes.s10),
          SvgPicture.asset(svgAssets.trashRed).inkWell(onTap: () {
            // settingPvr.showDeleteAddressSuccess(
            //     context, () => route.pop(context));

            showDialog(
                context: context,
                builder: (context) {
                  return CustomConfirmationDialog(
                      message: "Are you sure you want to delete Address ?",
                      onCancel: () => route.pop(context),
                      onConfirm: () => slCtrl.removeLocation(e, context));
                });
          })
        ])
      ]).padding(all: Sizes.s15));
    });
  }
}
