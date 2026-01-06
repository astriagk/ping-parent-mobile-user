import '../../../config.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
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
