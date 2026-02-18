import '../../config.dart';
import '../../api/models/subscription_recommendations_response.dart';
import 'subscription_header_section.dart';
import 'subscription_price_section.dart';
import 'subscription_features_section.dart';
import 'subscription_kids_info.dart';
import 'subscription_badge_label.dart';

class SubscriptionCard extends StatelessWidget {
  final RecommendedPlan plan;
  final VoidCallback? onSubscribe;

  const SubscriptionCard({
    super.key,
    required this.plan,
    this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final showBadge =
        plan.isCurrentPlan || plan.isRecommended || plan.isUpgrade;
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
        Container(
          margin: EdgeInsets.only(top: showBadge ? Sizes.s12 : 0),
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
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubscriptionHeaderSection(plan: plan),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubscriptionPriceSection(plan: plan)
                        .padding(vertical: Sizes.s8),
                    DottedLine(
                      alignment: WrapAlignment.center,
                      dashLength: 5.0,
                      dashGapLength: 2.0,
                      lineThickness: 1,
                      dashColor: appColor(context).appTheme.stroke,
                      direction: Axis.horizontal,
                    ).padding(vertical: Sizes.s8),
                    SubscriptionKidsInfo(plan: plan),
                    SubscriptionFeaturesSection(plan: plan)
                        .padding(top: Sizes.s8),
                    if (plan.isCurrentPlan)
                      _buildActiveStatusRow(context)
                    else
                      CommonButton(
                        text: plan.isUpgrade
                            ? '${appFonts.upgradeFor} ₹${plan.upgradePrice ?? plan.calculatedPrice}'
                            : 'Subscribe Now',
                        bgColor: plan.isUpgrade
                            ? appColor(context).appTheme.yellowIcon
                            : appColor(context).appTheme.activeColor,
                        onTap: onSubscribe,
                      ).padding(top: Sizes.s12),
                  ],
                ).padding(all: Sizes.s12),
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
              child: SubscriptionBadgeLabel(
                text: badgeText,
                type: badgeType,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActiveStatusRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Sizes.s12),
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.s16,
        vertical: Sizes.s10,
      ),
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
              color:
                  appColor(context).appTheme.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: Sizes.s14,
              color: appColor(context).appTheme.success,
            ),
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
