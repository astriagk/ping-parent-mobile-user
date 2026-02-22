import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/widgets/subscription_card/subscription_card.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/subscriptions_provider.dart';
import 'current_subscription_banner.dart';

class SubscriptionPlansList extends StatelessWidget {
  final SubscriptionsProvider subscriptionsCtrl;
  final RazorpayProvider razorpayCtrl;
  final bool isActivatingSubscription;
  final void Function(
    String planId,
    bool isUpgrade,
    int amount,
    String description,
  ) onSubscribeTap;

  const SubscriptionPlansList({
    super.key,
    required this.subscriptionsCtrl,
    required this.razorpayCtrl,
    required this.isActivatingSubscription,
    required this.onSubscribeTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubscription = subscriptionsCtrl.currentSubscription != null;
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
      itemCount: visiblePlans.length + (hasSubscription ? 1 : 0),
      itemBuilder: (context, index) {
        if (hasSubscription && index == 0) {
          final currentPlan = subscriptionsCtrl.recommendedPlans
              .where((p) => p.isCurrentPlan)
              .toList();
          final planName = currentPlan.isNotEmpty
              ? currentPlan.first.planName
              : 'Current Plan';
          return CurrentSubscriptionBanner(
            currentSub: subscriptionsCtrl.currentSubscription!,
            planName: planName,
          );
        }

        final planIndex = hasSubscription ? index - 1 : index;
        final plan = visiblePlans[planIndex];

        VoidCallback? onSubscribe;
        if (plan.isCurrentPlan) {
          onSubscribe = null;
        } else if (razorpayCtrl.isLoading || isActivatingSubscription) {
          onSubscribe = null;
        } else {
          final amount = plan.upgradePrice ?? plan.calculatedPrice;
          onSubscribe = () => onSubscribeTap(
                plan.planId,
                plan.isUpgrade,
                amount,
                plan.planName,
              );
        }

        return SubscriptionCard(
          plan: plan,
          onSubscribe: onSubscribe,
        ).paddingOnly(bottom: Sizes.s15);
      },
    );
  }
}
