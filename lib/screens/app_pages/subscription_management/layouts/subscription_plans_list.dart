import 'package:skolo/config.dart';
import 'package:skolo/widgets/subscription_card/subscription_card.dart';
import 'package:skolo/provider/app_pages_providers/subscriptions_provider.dart';
import 'current_subscription_banner.dart';
import 'partial_coverage_section.dart';
import 'redeem_code_section.dart';

class SubscriptionPlansList extends StatefulWidget {
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
  State<SubscriptionPlansList> createState() => _SubscriptionPlansListState();
}

class _SubscriptionPlansListState extends State<SubscriptionPlansList> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionsCtrl = widget.subscriptionsCtrl;
    final razorpayCtrl = widget.razorpayCtrl;

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

    // Order: plans → current-sub banner → redeem → partial coverage
    // Plans block is always index 0; remaining are header items after it.
    int trailerCount = 1; // redeem always
    if (showPartialCoverage) trailerCount++;
    if (hasSubscription) trailerCount++;

    final totalItems = (visiblePlans.isNotEmpty ? 1 : 0) + trailerCount;

    return ListView.builder(
      padding: EdgeInsets.only(top: Sizes.s20, bottom: Sizes.s100),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        // ── 0: Subscription plan cards (PageView) ──
        if (index == 0 && visiblePlans.isNotEmpty) {
          return _buildPlansCarousel(context, visiblePlans, razorpayCtrl);
        }

        // Offset for trailer items
        final trailerIndex = index - (visiblePlans.isNotEmpty ? 1 : 0);
        int offset = 0;

        // ── Current subscription banner ──
        if (hasSubscription) {
          if (trailerIndex == offset) {
            final currentPlan = subscriptionsCtrl.recommendedPlans
                .where((p) => p.isCurrentPlan)
                .toList();
            final planName = currentPlan.isNotEmpty
                ? currentPlan.first.planName
                : 'Current Plan';
            return CurrentSubscriptionBanner(
              currentSub: selfPaySub,
              planName: planName,
            ).paddingSymmetric(horizontal: Sizes.s20);
          }
          offset++;
        }

        // ── Redeem code ──
        if (trailerIndex == offset) {
          return RedeemCodeSection(
            onRedeem: subscriptionsCtrl.redeemSubscriptionCode,
            providerError: subscriptionsCtrl.redeemErrorMessage,
          ).paddingSymmetric(horizontal: Sizes.s20);
        }
        offset++;

        // ── Partial coverage ──
        if (showPartialCoverage && trailerIndex == offset) {
          return PartialCoverageSection(
            coveredStudents: summary.coveredStudents,
            uncoveredStudents: summary.uncoveredStudents,
          ).paddingSymmetric(horizontal: Sizes.s20);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPlansCarousel(
    BuildContext context,
    List visiblePlans,
    RazorpayProvider razorpayCtrl,
  ) {
    return Column(
      children: [
        // Dots above cards — fixed position, never affected by card content
        if (visiblePlans.length > 1) ...[
          _PageDots(count: visiblePlans.length, current: _currentPage),
          VSpace(Sizes.s10),
        ],

        // Fixed height — card body scrolls internally so no overflow possible
        SizedBox(
          height: Sizes.s385,
          child: PageView.builder(
            controller: _pageController,
            clipBehavior: Clip.none,
            itemCount: visiblePlans.length,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, planIndex) {
              final plan = visiblePlans[planIndex];

              VoidCallback? onSubscribe;
              if (plan.isCurrentPlan) {
                onSubscribe = null;
              } else if (razorpayCtrl.isLoading ||
                  widget.isActivatingSubscription) {
                onSubscribe = null;
              } else {
                final amount = plan.upgradePrice ?? plan.calculatedPrice;
                onSubscribe = () => widget.onSubscribeTap(
                      plan.planId,
                      plan.isUpgrade,
                      amount,
                      plan.planName,
                      plan.kidsCovered,
                    );
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.s8),
                child: SubscriptionCard(
                  plan: plan,
                  onSubscribe: onSubscribe,
                  isActive: planIndex == _currentPage,
                ),
              );
            },
          ),
        ),

        VSpace(Sizes.s16),
      ],
    );
  }
}

// ── Page dot indicators ───────────────────────────────────────────────────────

class _PageDots extends StatelessWidget {
  final int count;
  final int current;

  const _PageDots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: Sizes.s3),
          width: isActive ? Sizes.s16 : Sizes.s6,
          height: Sizes.s6,
          decoration: BoxDecoration(
            color: isActive
                ? appColor(context).appTheme.primary
                : appColor(context).appTheme.primary.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(Sizes.s3),
          ),
        );
      }),
    );
  }
}
