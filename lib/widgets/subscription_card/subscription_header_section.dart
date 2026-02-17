import '../../config.dart';
import '../../api/models/subscription_recommendations_response.dart';

class SubscriptionHeaderSection extends StatelessWidget {
  final RecommendedPlan plan;

  const SubscriptionHeaderSection({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors;
    final Color accentColor;
    final IconData iconData;

    if (plan.isCurrentPlan) {
      gradientColors = [
        appColor(context).appTheme.success.withValues(alpha: 0.15),
        appColor(context).appTheme.success.withValues(alpha: 0.05),
      ];
      accentColor = appColor(context).appTheme.success;
      iconData = Icons.verified_rounded;
    } else if (plan.isUpgrade) {
      gradientColors = [
        appColor(context).appTheme.yellowIcon.withValues(alpha: 0.15),
        appColor(context).appTheme.yellowIcon.withValues(alpha: 0.05),
      ];
      accentColor = appColor(context).appTheme.yellowIcon;
      iconData = Icons.star_rounded;
    } else {
      gradientColors = [
        appColor(context).appTheme.primary.withValues(alpha: 0.22),
        appColor(context).appTheme.primary.withValues(alpha: 0.08),
      ];
      accentColor = appColor(context).appTheme.primary;
      iconData = Icons.star_rounded;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.s8,
                    vertical: Sizes.s3,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(Sizes.s4),
                  ),
                  child: TextWidgetCommon(
                    text: plan.planType.toUpperCase(),
                    style: AppCss.lexendMedium10.textColor(accentColor),
                  ),
                ),
                VSpace(Sizes.s5),
                TextWidgetCommon(
                  text: plan.planName,
                  style: AppCss.lexendSemiBold16
                      .textColor(appColor(context).appTheme.darkText),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(Sizes.s10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              size: Sizes.s20,
              color: accentColor,
            ),
          ),
        ],
      ).padding(all: Sizes.s12),
    );
  }
}
