import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/widgets/common_empty_state.dart';
import 'package:taxify_user_ui/widgets/common_error_state.dart';
import 'package:taxify_user_ui/widgets/skeletons/student_card_skeleton.dart';
import '../../../widgets/subscription_card/subscription_card.dart';
import '../../../provider/app_pages_providers/subscriptions_provider.dart';
import '../../../widgets/loading/payment_loading_overlay.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> {
  bool _isActivatingSubscription = false;
  String? _pendingPlanId;
  bool _pendingIsUpgrade = false;
  late final RazorpayProvider _razorpayProvider;

  @override
  void initState() {
    super.initState();
    _razorpayProvider = context.read<RazorpayProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SubscriptionsProvider>().onInit();
        _razorpayProvider.addListener(_onPaymentStateChanged);
      }
    });
  }

  @override
  void dispose() {
    _razorpayProvider.removeListener(_onPaymentStateChanged);
    super.dispose();
  }

  void _onPaymentStateChanged() {
    final razorpayCtrl = context.read<RazorpayProvider>();
    if (razorpayCtrl.isPaymentSuccess && _pendingPlanId != null && !_isActivatingSubscription) {
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
                      : subscriptionsCtrl.recommendedPlans.isEmpty
                          ? CommonEmptyState(
                              mainText: appFonts.noSubscriptionPlansAvailable,
                              descriptionText:
                                  appFonts.noSubscriptionPlansDescription,
                              buttonText: appFonts.refresh,
                              onButtonTap: () =>
                                  subscriptionsCtrl.fetchRecommendations(),
                            )
                          : Builder(
                              builder: (context) {
                                final hasSubscription =
                                    subscriptionsCtrl.currentSubscription != null;
                                // Filter out downgrade plans when user has an active subscription
                                final visiblePlans = hasSubscription
                                    ? subscriptionsCtrl.recommendedPlans
                                        .where((p) => p.isCurrentPlan || p.isUpgrade)
                                        .toList()
                                    : subscriptionsCtrl.recommendedPlans;

                                return ListView.builder(
                                  padding: EdgeInsets.only(
                                    left: Sizes.s20,
                                    right: Sizes.s20,
                                    top: Sizes.s20,
                                    bottom: Sizes.s100,
                                  ),
                                  itemCount: visiblePlans.length +
                                      (hasSubscription ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (hasSubscription && index == 0) {
                                      return _buildCurrentSubscriptionBanner(
                                        context,
                                        subscriptionsCtrl,
                                      );
                                    }
                                    final planIndex =
                                        hasSubscription ? index - 1 : index;
                                    final plan = visiblePlans[planIndex];

                                    VoidCallback? onSubscribe;
                                    if (plan.isCurrentPlan) {
                                      onSubscribe = null;
                                    } else if (razorpayCtrl.isLoading ||
                                        _isActivatingSubscription) {
                                      onSubscribe = null;
                                    } else {
                                      final amount = plan.upgradePrice ??
                                          plan.calculatedPrice;
                                      onSubscribe = () {
                                        _pendingPlanId = plan.planId;
                                        _pendingIsUpgrade = plan.isUpgrade;
                                        razorpayCtrl.initiatePayment(
                                          amount: amount,
                                          subscriptionId: plan.planId,
                                          description: plan.planName,
                                        );
                                      };
                                    }

                                    return SubscriptionCard(
                                      plan: plan,
                                      onSubscribe: onSubscribe,
                                    ).paddingOnly(bottom: Sizes.s15);
                                  },
                                );
                              },
                            ),
              if (razorpayCtrl.isLoading || _isActivatingSubscription) PaymentLoadingOverlay(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentSubscriptionBanner(
    BuildContext context,
    SubscriptionsProvider subscriptionsCtrl,
  ) {
    final currentSub = subscriptionsCtrl.currentSubscription!;
    final currentPlan = subscriptionsCtrl.recommendedPlans
        .where((p) => p.isCurrentPlan)
        .toList();
    final planName =
        currentPlan.isNotEmpty ? currentPlan.first.planName : 'Current Plan';

    return Container(
      margin: EdgeInsets.only(bottom: Sizes.s15),
      padding: EdgeInsets.all(Sizes.s16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColor(context).appTheme.success.withValues(alpha: 0.12),
            appColor(context).appTheme.success.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(Sizes.s12),
        border: Border.all(
          color: appColor(context).appTheme.success.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Sizes.s10),
            decoration: BoxDecoration(
              color:
                  appColor(context).appTheme.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_rounded,
              color: appColor(context).appTheme.success,
              size: Sizes.s24,
            ),
          ),
          HSpace(Sizes.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgetCommon(
                  text: appFonts.yourCurrentPlan,
                  style: AppCss.lexendMedium12
                      .textColor(appColor(context).appTheme.success),
                ),
                VSpace(Sizes.s4),
                TextWidgetCommon(
                  text: planName,
                  style: AppCss.lexendSemiBold16
                      .textColor(appColor(context).appTheme.darkText),
                ),
                VSpace(Sizes.s4),
                TextWidgetCommon(
                  text:
                      '${currentSub.remainingDays} ${appFonts.remainingDays} • ₹${currentSub.remainingValue} value',
                  style: AppCss.lexendRegular12
                      .textColor(appColor(context).appTheme.lightText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
