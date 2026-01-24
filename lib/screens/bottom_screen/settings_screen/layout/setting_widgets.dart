import '../../../../config.dart';

class SettingScreenWidgets {
  //My wallet Balance layout
  Widget myWalletLayout(context, {String? userName, String? userEmail}) {
    return Column(children: [
      TextWidgetCommon(
          text: userName ?? appFonts.yourName,
          style: AppCss.lexendRegular14
              .textColor(appColor(context).appTheme.darkText)),
      VSpace(Sizes.s5),
      TextWidgetCommon(
          text: userEmail ?? appFonts.yourEmail,
          style: AppCss.lexendMedium12
              .textColor(appColor(context).appTheme.lightText)),
      Column(children: [
        VSpace(Sizes.s5),
        TextWidgetCommon(
            text: appFonts.myWalletBalance,
            style: AppCss.lexendRegular12.textColor(
                appColor(context).appTheme.darkText.withValues(alpha: .6))),
        VSpace(Sizes.s5),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextWidgetCommon(
              text:
                  '${getSymbol(context)}${(currency(context).currencyVal * double.parse(appFonts.walletValue)).toStringAsFixed(2)}',
              style: AppCss.lexendSemiBold15
                  .textColor(appColor(context).appTheme.darkText)),
          HSpace(Sizes.s6),
          SvgPicture.asset(svgAssets.rightArrowMyWallet)
        ]),
        VSpace(Sizes.s5)
      ]).settingWalletExtension(context)
    ]);
  }

//setting screen all list main title layout
  Widget mainListTitlesLayout(e, context) {
    return Column(children: [
      TextWidgetCommon(
          text: e.value['title'],
          style: AppCss.lexendRegular14.textColor(
              e.value["title"] == appFonts.alertZone
                  ? appColor(context).appTheme.alertZone
                  : appColor(context).appTheme.lightText)),
      VSpace(Sizes.s15)
    ]);
  }

//setting screen list icon, title,arrow layout
  Widget listIconTitleArrowLayout(e, context, a) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: e.value["title"] == appFonts.alertZone
                    ? appColor(context)
                        .appTheme
                        .alertZone
                        .withValues(alpha: 0.10)
                    : appColor(context).appTheme.white,
                border: Border.all(
                    color: e.value["title"] == appFonts.alertZone
                        ? appColor(context).appTheme.trans
                        : appColor(context).appTheme.stroke)),
            child: SvgPicture.asset(a.value['icon']).padding(all: Sizes.s11)),
        HSpace(Sizes.s15),
        TextWidgetCommon(
            text: a.value['subTitle'],
            style: AppCss.lexendRegular14.textColor(
                e.value["title"] == appFonts.alertZone
                    ? appColor(context).appTheme.alertZone
                    : appColor(context).appTheme.darkText))
      ]),
      e.value["title"] != appFonts.alertZone
          ? SvgPicture.asset(svgAssets.arrow)
          : const SizedBox.shrink()
    ]);
  }

  //setting screen divider layout
  Widget settingDivider(e, context) => Divider(
          color: e.value["title"] == appFonts.alertZone
              ? appColor(context).appTheme.alertZone.withValues(alpha: 0.20)
              : appColor(context).appTheme.stroke,
          height: 0)
      .padding(vertical: Sizes.s12);

  //setting screen profile image layout
  Widget settingProfileImage({String? photoUrl}) {
    return Align(
      alignment: Alignment.topCenter,
      child: photoUrl != null && photoUrl.isNotEmpty
          ? Image.network(
              photoUrl,
              height: Sizes.s82,
              width: Sizes.s82,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(imageAssets.profileImg,
                    height: Sizes.s82, width: Sizes.s82);
              },
            ).clipRRect(all: Sizes.s41)
          : Image.asset(imageAssets.profileImg,
              height: Sizes.s82, width: Sizes.s82),
    ).padding(top: Sizes.s30);
  }
}
