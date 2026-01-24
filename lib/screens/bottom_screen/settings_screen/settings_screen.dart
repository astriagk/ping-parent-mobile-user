import 'package:taxify_user_ui/config.dart';
import '../../../provider/app_pages_providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<SettingProvider, DashBoardProvider, UserProvider>(
        builder: (context, settingCtrl, dash, userProvider, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => settingCtrl.init()),
          child: Scaffold(
              body: SingleChildScrollView(
                  controller: dash.scrollViewController,
                  child: Stack(children: [
                    Image.asset(imageAssets.rectangle,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill),
                    SingleChildScrollView(
                        child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: ShapeDecoration(
                                    color: appColor(context).appTheme.white,
                                    shape: SmoothRectangleBorder(
                                        side: const BorderSide(
                                            color: Color(0xFFF5F6F7)),
                                        borderRadius: SmoothBorderRadius.only(
                                            topLeft: SmoothRadius(
                                                cornerRadius: Sizes.s20,
                                                cornerSmoothing: 1),
                                            topRight: SmoothRadius(
                                                cornerRadius: Sizes.s20,
                                                cornerSmoothing: 1)))),
                                child: Column(children: [
                                  //My wallet Balance layout
                                  SettingScreenWidgets().myWalletLayout(
                                    context,
                                    userName: userProvider.userData?.name,
                                    userEmail: userProvider.userData?.email,
                                  ),
                                  //setting screen all data list layout
                                  const SettingListLayout()
                                ]).padding(
                                    top: Sizes.s46,
                                    horizontal: Sizes.s20,
                                    bottom: Sizes.s50))
                            .paddingDirectional(vertical: Sizes.s70)),
                    //setting screen profile image layout
                    SettingScreenWidgets().settingProfileImage(
                      photoUrl: userProvider.userData?.photoUrl,
                    )
                  ]))));
    });
  }
}
