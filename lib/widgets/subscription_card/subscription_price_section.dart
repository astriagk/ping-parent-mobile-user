import '../../config.dart';
import '../../api/models/subscription_recommendations_response.dart';

class SubscriptionPriceSection extends StatelessWidget {
  final RecommendedPlan plan;

  const SubscriptionPriceSection({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        plan.discount != null && plan.calculatedPrice < plan.originalPrice;
    final priceColor = plan.isCurrentPlan
        ? appColor(context).appTheme.lightText
        : appColor(context).appTheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextWidgetCommon(
              text: '₹',
              style: AppCss.lexendSemiBold24.textColor(priceColor),
            ),
            HSpace(Sizes.s4),
            TextWidgetCommon(
              text: plan.calculatedPrice.toString(),
              style: AppCss.lexendSemiBold24.textColor(priceColor),
            ),
            HSpace(Sizes.s6),
            TextWidgetCommon(
              text: '/${plan.planType}',
              style: AppCss.lexendRegular12
                  .textColor(appColor(context).appTheme.lightText),
            ).paddingOnly(bottom: Sizes.s4),
            if (hasDiscount) ...[
              HSpace(Sizes.s8),
              TextWidgetCommon(
                text: '₹${plan.originalPrice}',
                style: AppCss.lexendRegular12
                    .textColor(appColor(context).appTheme.lightText)
                    .copyWith(decoration: TextDecoration.lineThrough),
              ).paddingOnly(bottom: Sizes.s4),
            ],
          ],
        ),
        if (hasDiscount) ...[
          VSpace(Sizes.s6),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.s8,
              vertical: Sizes.s4,
            ),
            decoration: BoxDecoration(
              color:
                  appColor(context).appTheme.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Sizes.s4),
            ),
            child: TextWidgetCommon(
              text:
                  '${plan.discount!.label}: save ₹${plan.discount!.amount}',
              style: AppCss.lexendMedium10
                  .textColor(appColor(context).appTheme.success),
            ),
          ),
        ],
        if (plan.isUpgrade && plan.proration != null) ...[
          VSpace(Sizes.s6),
          TextWidgetCommon(
            text:
                'Prorated from ₹${plan.proration!.currentRemainingValue} credit',
            style: AppCss.lexendRegular11
                .textColor(appColor(context).appTheme.lightText),
          ),
          VSpace(Sizes.s4),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.s8,
              vertical: Sizes.s4,
            ),
            decoration: BoxDecoration(
              color:
                  appColor(context).appTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Sizes.s4),
            ),
            child: TextWidgetCommon(
              text: 'You pay ₹${plan.upgradePrice ?? plan.proration!.proratedUpgradePrice}',
              style: AppCss.lexendMedium10
                  .textColor(appColor(context).appTheme.primary),
            ),
          ),
        ],
        if (plan.reason.isNotEmpty) ...[
          VSpace(Sizes.s4),
          TextWidgetCommon(
            text: plan.reason,
            style: AppCss.lexendRegular11
                .textColor(appColor(context).appTheme.lightText),
          ),
        ],
      ],
    );
  }
}
