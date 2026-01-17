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

    return Row(
      children: [
        SvgPicture.asset(
          svgAssets.person,
          height: Sizes.s16,
          width: Sizes.s16,
        ),
        HSpace(Sizes.s8),
        TextWidgetCommon(
          text: minKids == maxKids
              ? '$minKids Kid${minKids > 1 ? 's' : ''}'
              : '$minKids-$maxKids Kids',
          style: AppCss.lexendMedium12
              .textColor(appColor(context).appTheme.darkText),
        ),
      ],
    );
  }
}
