import '../../config.dart';

class SubscriptionHeaderSection extends StatelessWidget {
  final Map<String, dynamic> subscriptionData;

  const SubscriptionHeaderSection({
    super.key,
    required this.subscriptionData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColor(context).appTheme.primary.withValues(alpha: 0.18),
            appColor(context).appTheme.primary.withValues(alpha: 0.05),
          ],
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
                    color: appColor(context)
                        .appTheme
                        .primary
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(Sizes.s4),
                  ),
                  child: TextWidgetCommon(
                    text: subscriptionData['plan_type']
                            ?.toString()
                            .toUpperCase() ??
                        '',
                    style: AppCss.lexendMedium10
                        .textColor(appColor(context).appTheme.primary),
                  ),
                ),
                VSpace(Sizes.s5),
                TextWidgetCommon(
                  text: subscriptionData['plan_name'] ?? '',
                  style: AppCss.lexendSemiBold16
                      .textColor(appColor(context).appTheme.darkText),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(Sizes.s10),
            decoration: BoxDecoration(
              color: appColor(context).appTheme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              svgAssets.star,
              height: Sizes.s20,
              width: Sizes.s20,
              colorFilter: ColorFilter.mode(
                appColor(context).appTheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ).padding(all: Sizes.s12),
    );
  }
}
