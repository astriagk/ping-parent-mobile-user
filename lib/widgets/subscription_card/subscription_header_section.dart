import '../../config.dart';

class SubscriptionHeaderSection extends StatelessWidget {
  final Map<String, dynamic> subscriptionData;

  const SubscriptionHeaderSection({
    super.key,
    required this.subscriptionData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextWidgetCommon(
            text: subscriptionData['plan_name'] ?? '',
            style: AppCss.lexendSemiBold16
                .textColor(appColor(context).appTheme.darkText),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.s12,
            vertical: Sizes.s6,
          ),
          decoration: BoxDecoration(
            color: appColor(context).appTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Sizes.s20),
          ),
          child: TextWidgetCommon(
            text: subscriptionData['plan_type']?.toString().toUpperCase() ?? '',
            style: AppCss.lexendMedium10
                .textColor(appColor(context).appTheme.primary),
          ),
        ),
      ],
    );
  }
}
