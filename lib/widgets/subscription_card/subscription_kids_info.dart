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

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.s10,
        vertical: Sizes.s5,
      ),
      decoration: BoxDecoration(
        color: appColor(context).appTheme.primary.withValues(alpha: 0.08),
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
              appColor(context).appTheme.primary,
              BlendMode.srcIn,
            ),
          ),
          HSpace(Sizes.s6),
          TextWidgetCommon(
            text: kidText,
            style: AppCss.lexendMedium12
                .textColor(appColor(context).appTheme.primary),
          ),
        ],
      ),
    );
  }
}
