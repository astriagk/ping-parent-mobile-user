import 'package:skolo/config.dart';
import 'package:skolo/widgets/subscription_card/subscription_card.dart';
import 'package:skolo/provider/app_pages_providers/subscriptions_provider.dart';
import 'current_subscription_banner.dart';
import 'partial_coverage_section.dart';

class SubscriptionPlansList extends StatelessWidget {
  final SubscriptionsProvider subscriptionsCtrl;
  final RazorpayProvider razorpayCtrl;
  final bool isActivatingSubscription;
  final void Function(
    String planId,
    bool isUpgrade,
    int amount,
    String description,
    int kidsCovered,
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
    final selfPaySub = subscriptionsCtrl.firstSelfPaySubscription;
    final hasSubscription = selfPaySub != null;

    final visiblePlans = hasSubscription
        ? subscriptionsCtrl.recommendedPlans
            .where((p) => p.isCurrentPlan || p.isUpgrade)
            .toList()
        : subscriptionsCtrl.recommendedPlans;

    final summary = subscriptionsCtrl.parentSummary;
    final showPartialCoverage = subscriptionsCtrl.hasPartialCoverage &&
        summary != null &&
        !hasSubscription;

    // Header items: optional partial-coverage section + optional current-subscription banner
    int headerCount = 0;
    if (showPartialCoverage) headerCount++;
    if (hasSubscription) headerCount++;

    return ListView.builder(
      padding: EdgeInsets.only(
        left: Sizes.s20,
        right: Sizes.s20,
        top: Sizes.s20,
        bottom: Sizes.s100,
      ),
      itemCount: visiblePlans.length + headerCount,
      itemBuilder: (context, index) {
        int offset = 0;

        // Partial coverage info row
        if (showPartialCoverage) {
          if (index == offset) {
            return PartialCoverageSection(
              coveredStudents: summary.coveredStudents,
              uncoveredStudents: summary.uncoveredStudents,
            );
          }
          offset++;
        }

        // Current subscription banner (self-pay only)
        if (hasSubscription) {
          if (index == offset) {
            final currentPlan = subscriptionsCtrl.recommendedPlans
                .where((p) => p.isCurrentPlan)
                .toList();
            final planName = currentPlan.isNotEmpty
                ? currentPlan.first.planName
                : 'Current Plan';
            return CurrentSubscriptionBanner(
              currentSub: selfPaySub,
              planName: planName,
            );
          }
          offset++;
        }

        final planIndex = index - offset;
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
                plan.kidsCovered,
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
