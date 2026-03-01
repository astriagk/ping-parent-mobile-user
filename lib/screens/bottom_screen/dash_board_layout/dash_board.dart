import 'package:skolo/config.dart';
import 'package:skolo/provider/app_pages_providers/user_provider.dart';
import 'package:skolo/provider/app_pages_providers/subscriptions_provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int? _lastTabIndex;

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

  /// Central tab refresh — fetches fresh data when switching between bottom tabs.
  void _onTabChanged(BuildContext context, int newTab) {
    if (_lastTabIndex == newTab) return;
    final isFirstVisit = _lastTabIndex == null;
    _lastTabIndex = newTab;
    if (isFirstVisit) return; // first load handled by initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      switch (newTab) {
        case 0:
          context.read<TripTrackingProvider>().fetchActiveTrips();
          break;
        case 2:
          context
              .read<SubscriptionsProvider>()
              .fetchRecommendations(isRefresh: true);
          break;
        case 3:
          context.read<UserProvider>().fetchUserProfile();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardProvider>(builder: (context1, bottomCtrl, child) {
      _onTabChanged(context, bottomCtrl.currentTab);
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
