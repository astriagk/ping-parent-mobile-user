import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/api/models/subscription_recommendations_response.dart';

class CurrentSubscriptionBanner extends StatelessWidget {
  final CurrentSubscription currentSub;
  final String planName;

  const CurrentSubscriptionBanner({
    super.key,
    required this.currentSub,
    required this.planName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Sizes.s15),
      padding: EdgeInsets.all(Sizes.s16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColor(context).appTheme.success.withValues(alpha: 0.12),
            appColor(context).appTheme.success.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(Sizes.s12),
        border: Border.all(
          color: appColor(context).appTheme.success.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Sizes.s10),
            decoration: BoxDecoration(
              color:
                  appColor(context).appTheme.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_rounded,
              color: appColor(context).appTheme.success,
              size: Sizes.s24,
            ),
          ),
          HSpace(Sizes.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgetCommon(
                  text: appFonts.yourCurrentPlan,
                  style: AppCss.lexendMedium12
                      .textColor(appColor(context).appTheme.success),
                ),
                VSpace(Sizes.s4),
                TextWidgetCommon(
                  text: planName,
                  style: AppCss.lexendSemiBold16
                      .textColor(appColor(context).appTheme.darkText),
                ),
                VSpace(Sizes.s4),
                TextWidgetCommon(
                  text:
                      '${currentSub.remainingDays} ${appFonts.remainingDays} • ₹${currentSub.remainingValue} value',
                  style: AppCss.lexendRegular12
                      .textColor(appColor(context).appTheme.lightText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
