import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/user_provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    super.initState();
    // Fetch user data if not already loaded (handles app restart with existing session)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = context.read<UserProvider>();
      if (!userProvider.hasUserData && !userProvider.isFetching) {
        await userProvider.fetchUserProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardProvider>(builder: (context1, bottomCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => bottomCtrl.onInit()),
          child: DirectionalityRtl(
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: appColor(context).appTheme.screenBg,
                  extendBody: true,
                  bottomNavigationBar: // bottom navigation Bar layout
                      const DashBoardLayout(),
                  appBar: bottomCtrl.currentTab != 0
                      ? DashAppBar(index: bottomCtrl.currentTab)
                      : null,
                  body: bottomCtrl.currentTab == 0
                      ? DashAppBar(index: bottomCtrl.currentTab)
                      : bottomCtrl.screens[bottomCtrl.currentTab])));
    });
  }
}
