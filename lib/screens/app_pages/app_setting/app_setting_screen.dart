import 'package:taxify_user_ui/config.dart';

class AppSettingScreen extends StatelessWidget {
  const AppSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<SettingProvider, AppSettingProvider, LanguageProvider>(
        builder: (context, settingCtrl, appCtrl, languageCtrl, child) {
      return Scaffold(
          appBar: CommonAppBarLayout(title: appFonts.appSettings),
          body: Column(mainAxisSize: MainAxisSize.min, children: [
            ...appArray
                .appSetting(appCtrl.isNotificationSwitch)
                .asMap()
                .entries
                .map((e) {
              return Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        CommonIconButton(icon: e.value['icon'].toString()),
                        HSpace(Sizes.s12),
                        Text(language(context, e.value['title']),
                            style: AppCss.lexendRegular14
                                .textColor(appColor(context).appTheme.darkText))
                      ]).padding(vertical: Sizes.s15),
                      e.key == 0
                          ? SwitchCommon(
                              onToggle: (value) => appCtrl.notificationSwitch(),
                              value: appCtrl.isNotificationSwitch)
                          : SvgPicture.asset(svgAssets.arrow,
                              colorFilter: ColorFilter.mode(
                                  appColor(context).appTheme.lightText,
                                  BlendMode.srcIn))
                    ]).inkWell(
                    onTap: () => //app setting screen onTap
                        settingCtrl.appSettingOnTap(e.key, context)),
                if (e.key !=
                    appArray.appSetting(appCtrl.isNotificationSwitch).length -
                        1)
                  Divider(color: appColor(context).appTheme.stroke, height: 0)
              ]);
            })
          ])
              .padding(horizontal: Sizes.s15)
              .decorated(
                  color: appColor(context).appTheme.bgBox, allRadius: Sizes.s12)
              .padding(all: Sizes.s20));
    });
  }
}
