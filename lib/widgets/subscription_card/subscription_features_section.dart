import '../../config.dart';
import '../../api/models/subscription_recommendations_response.dart';

class SubscriptionFeaturesSection extends StatelessWidget {
  final RecommendedPlan plan;

  const SubscriptionFeaturesSection({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: plan.features.map((feature) {
        return Row(
          children: [
            Container(
              width: Sizes.s20,
              height: Sizes.s20,
              decoration: BoxDecoration(
                color: feature.enabled
                    ? appColor(context)
                        .appTheme
                        .success
                        .withValues(alpha: 0.12)
                    : appColor(context).appTheme.stroke.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                feature.enabled ? Icons.check : Icons.close,
                size: Sizes.s12,
                color: feature.enabled
                    ? appColor(context).appTheme.success
                    : appColor(context).appTheme.lightText,
              ),
            ),
            HSpace(Sizes.s8),
            Expanded(
              child: TextWidgetCommon(
                text: feature.label,
                style: AppCss.lexendRegular12.textColor(
                  feature.enabled
                      ? appColor(context).appTheme.darkText
                      : appColor(context).appTheme.lightText,
                ),
              ),
            ),
          ],
        ).paddingOnly(bottom: Sizes.s8);
      }).toList(),
    );
  }
}
