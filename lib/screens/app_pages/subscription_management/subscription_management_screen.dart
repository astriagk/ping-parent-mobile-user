import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/widgets/common_empty_state.dart';
import 'package:taxify_user_ui/widgets/common_error_state.dart';
import 'package:taxify_user_ui/widgets/skeletons/student_card_skeleton.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/subscriptions_provider.dart';
import 'package:taxify_user_ui/widgets/loading/payment_loading_overlay.dart';
import 'layouts/school_coverage_card.dart';
import 'layouts/subscription_plans_list.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> with WidgetsBindingObserver {
  bool _isActivatingSubscription = false;
  String? _pendingPlanId;
  bool _pendingIsUpgrade = false;
  late final RazorpayProvider _razorpayProvider;
  int? _lastTabIndex;
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    _razorpayProvider = context.read<RazorpayProvider>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _razorpayProvider.addListener(_onPaymentStateChanged);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _razorpayProvider.removeListener(_onPaymentStateChanged);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    } else if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      if (_lastTabIndex == 2) {
        context
            .read<SubscriptionsProvider>()
            .fetchRecommendations(isRefresh: true);
      }
    }
  }

  void _onPaymentStateChanged() {
    final razorpayCtrl = context.read<RazorpayProvider>();
    if (razorpayCtrl.isPaymentSuccess &&
        _pendingPlanId != null &&
        !_isActivatingSubscription) {
      _activateSubscription(_pendingPlanId!, _pendingIsUpgrade);
    }
  }

  Future<void> _activateSubscription(String planId, bool isUpgrade) async {
    if (_isActivatingSubscription) return;
    setState(() => _isActivatingSubscription = true);

    final subscriptionsCtrl = context.read<SubscriptionsProvider>();
    if (isUpgrade) {
      await subscriptionsCtrl.upgradeSubscription(planId);
    } else {
      await subscriptionsCtrl.createSubscription(planId);
    }

    if (mounted) {
      final razorpayCtrl = context.read<RazorpayProvider>();
      razorpayCtrl.reset();
      setState(() {
        _isActivatingSubscription = false;
        _pendingPlanId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = context.watch<DashBoardProvider>().currentTab;
    if (currentTab == 2 && _lastTabIndex != 2) {
      final isFirstVisit = _lastTabIndex == null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context
              .read<SubscriptionsProvider>()
              .fetchRecommendations(isRefresh: !isFirstVisit);
        }
      });
    }
    _lastTabIndex = currentTab;

    return Consumer2<SubscriptionsProvider, RazorpayProvider>(
      builder: (context, subscriptionsCtrl, razorpayCtrl, child) {
        return Scaffold(
          body: Stack(
            children: [
              subscriptionsCtrl.isLoading
                  ? const StudentListSkeleton()
                  : subscriptionsCtrl.errorMessage != null
                      ? CommonErrorState(
                          title: appFonts.somethingWentWrong,
                          description: subscriptionsCtrl.errorMessage!,
                          buttonText: appFonts.refresh,
                          onButtonTap: () =>
                              subscriptionsCtrl.fetchRecommendations(),
                        )
                      : subscriptionsCtrl.coveredBySchool
                          ? SchoolCoverageCard(
                              currentSubscription:
                                  subscriptionsCtrl.currentSubscription,
                            )
                          : subscriptionsCtrl.recommendedPlans.isEmpty
                              ? CommonEmptyState(
                                  mainText:
                                      appFonts.noSubscriptionPlansAvailable,
                                  descriptionText:
                                      appFonts.noSubscriptionPlansDescription,
                                  buttonText: appFonts.refresh,
                                  onButtonTap: () =>
                                      subscriptionsCtrl.fetchRecommendations(),
                                )
                              : SubscriptionPlansList(
                                  subscriptionsCtrl: subscriptionsCtrl,
                                  razorpayCtrl: razorpayCtrl,
                                  isActivatingSubscription:
                                      _isActivatingSubscription,
                                  onSubscribeTap:
                                      (planId, isUpgrade, amount, description) {
                                    _pendingPlanId = planId;
                                    _pendingIsUpgrade = isUpgrade;
                                    razorpayCtrl.initiatePayment(
                                      amount: amount,
                                      subscriptionId: planId,
                                      description: description,
                                    );
                                  },
                                ),
              if (razorpayCtrl.isLoading || _isActivatingSubscription)
                PaymentLoadingOverlay(),
            ],
          ),
        );
      },
    );
  }
}
