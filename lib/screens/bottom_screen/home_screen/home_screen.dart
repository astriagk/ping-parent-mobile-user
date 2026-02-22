import 'package:taxify_user_ui/config.dart';
import 'layout/tracking_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int? _lastTabIndex;
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeScreenProvider>().init();
        context.read<ChooseRiderProvider>().onInit();
        context.read<TripTrackingProvider>().init();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    } else if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      if (_lastTabIndex == 0) {
        context.read<TripTrackingProvider>().fetchActiveTrips();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = context.watch<DashBoardProvider>().currentTab;
    if (currentTab == 0 && _lastTabIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<TripTrackingProvider>().fetchActiveTrips();
        }
      });
    }
    _lastTabIndex = currentTab;

    return Consumer3<ChooseRiderProvider, HomeScreenProvider,
        TripTrackingProvider>(
      builder: (context, chooseCtrl, homeCtrl, tripCtrl, child) {
        return Scaffold(
          body: ListView(padding: EdgeInsets.zero, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //card layout
              // CardLayout(),
              // tracking card
              TrackingCard(),
              // top categories layout
              TopCategories(),
              //today's offer layout
              TodayOfferLayout()
            ]).padding(horizontal: Sizes.s20, bottom: Sizes.s100)
          ]),
        );
      },
    );
  }
}
