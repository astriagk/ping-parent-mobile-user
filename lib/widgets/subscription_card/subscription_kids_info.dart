import '../../config.dart';
import '../../api/models/subscription_recommendations_response.dart';

class SubscriptionKidsInfo extends StatelessWidget {
  final RecommendedPlan plan;

  const SubscriptionKidsInfo({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final kidText =
        '${plan.kidsCovered} Kid${plan.kidsCovered > 1 ? 's' : ''} Covered';

    final Color accentColor;
    if (plan.isCurrentPlan) {
      accentColor = appColor(context).appTheme.success;
    } else if (plan.isUpgrade) {
      accentColor = appColor(context).appTheme.yellowIcon;
    } else {
      accentColor = appColor(context).appTheme.activeColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.s10,
        vertical: Sizes.s5,
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Sizes.s20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgAssets.person,
            height: Sizes.s14,
            width: Sizes.s14,
            colorFilter: ColorFilter.mode(
              accentColor,
              BlendMode.srcIn,
            ),
          ),
          HSpace(Sizes.s6),
          TextWidgetCommon(
            text: kidText,
            style: AppCss.lexendMedium12.textColor(accentColor),
          ),
        ],
      ),
    );
  }
}
