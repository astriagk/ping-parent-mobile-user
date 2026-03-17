import '../../config.dart';
import '../../api/models/subscription_recommendations_response.dart';
import 'subscription_header_section.dart';
import 'subscription_price_section.dart';
import 'subscription_features_section.dart';
import 'subscription_kids_info.dart';
import 'subscription_badge_label.dart';

class SubscriptionCard extends StatefulWidget {
  final RecommendedPlan plan;
  final VoidCallback? onSubscribe;
  final bool isActive;

  const SubscriptionCard({
    super.key,
    required this.plan,
    this.onSubscribe,
    this.isActive = true,
  });

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final showBadge = plan.isCurrentPlan || plan.isRecommended || plan.isUpgrade;
    final badgeText = plan.isCurrentPlan
        ? appFonts.currentPlan
        : plan.isUpgrade
            ? 'Upgrade'
            : 'Recommended';
    final badgeType = plan.isCurrentPlan
        ? 'current'
        : plan.isUpgrade
            ? 'upgrade'
            : 'recommended';

    final Color accentColor;
    if (plan.isCurrentPlan) {
      accentColor = appColor(context).appTheme.success;
    } else if (plan.isUpgrade) {
      accentColor = appColor(context).appTheme.yellowIcon;
    } else {
      accentColor = appColor(context).appTheme.activeColor;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Badge space always reserved so all cards align the same
        Container(
          margin: EdgeInsets.only(top: Sizes.s12),
          decoration: BoxDecoration(
            color: plan.isCurrentPlan
                ? appColor(context).appTheme.bgBox
                : appColor(context).appTheme.white,
            borderRadius: BorderRadius.circular(Sizes.s12),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.12),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Fixed header ──
                SubscriptionHeaderSection(plan: plan),

                // ── Scrollable content — fills space between header and button ──
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        Sizes.s12, Sizes.s10, Sizes.s12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubscriptionPriceSection(plan: plan),
                        VSpace(Sizes.s8),
                        DottedLine(
                          alignment: WrapAlignment.center,
                          dashLength: 5.0,
                          dashGapLength: 2.0,
                          lineThickness: 1,
                          dashColor: appColor(context).appTheme.stroke,
                          direction: Axis.horizontal,
                        ),
                        VSpace(Sizes.s8),
                        SubscriptionKidsInfo(plan: plan),
                        if (plan.features.isNotEmpty) ...[
                          VSpace(Sizes.s10),
                          SubscriptionFeaturesSection(plan: plan),
                        ],
                      ],
                    ),
                  ),
                ),

                // ── Button always pinned at the bottom ──
                Padding(
                  padding: EdgeInsets.all(Sizes.s12),
                  child: plan.isCurrentPlan
                      ? _buildActiveStatusRow(context)
                      : CommonButton(
                          text: plan.isUpgrade
                              ? '${appFonts.upgradeFor} ₹${plan.upgradePrice ?? plan.calculatedPrice}'
                              : 'Subscribe Now',
                          bgColor: plan.isUpgrade
                              ? appColor(context).appTheme.yellowIcon
                              : appColor(context).appTheme.activeColor,
                          onTap: widget.onSubscribe,
                        ),
                ),
              ],
            ),
          ),
        ),

        if (showBadge)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: SubscriptionBadgeLabel(text: badgeText, type: badgeType),
            ),
          ),
      ],
    );
  }

  Widget _buildActiveStatusRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Sizes.s16, vertical: Sizes.s10),
      decoration: BoxDecoration(
        color: appColor(context).appTheme.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Sizes.s20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(Sizes.s2),
            decoration: BoxDecoration(
              color: appColor(context).appTheme.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check,
                size: Sizes.s14,
                color: appColor(context).appTheme.success),
          ),
          HSpace(Sizes.s8),
          TextWidgetCommon(
            text: 'Active Plan',
            style: AppCss.lexendMedium12
                .textColor(appColor(context).appTheme.success),
          ),
        ],
      ),
    ).center();
  }
}
