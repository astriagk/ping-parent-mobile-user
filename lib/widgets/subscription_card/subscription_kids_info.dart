import '../../config.dart';

class SubscriptionKidsInfo extends StatelessWidget {
  final Map<String, dynamic> subscriptionData;

  const SubscriptionKidsInfo({
    super.key,
    required this.subscriptionData,
  });

  @override
  Widget build(BuildContext context) {
    final kids = subscriptionData['kids'] as Map<String, dynamic>?;
    final minKids = kids?['min'] ?? 0;
    final maxKids = kids?['max'] ?? 0;

    final kidText = minKids == maxKids
        ? '$minKids Kid${minKids > 1 ? 's' : ''}'
        : '$minKids-$maxKids Kids';

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
