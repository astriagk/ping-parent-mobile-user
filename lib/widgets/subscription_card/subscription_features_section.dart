import '../../config.dart';

class SubscriptionFeaturesSection extends StatelessWidget {
  final Map<String, dynamic> subscriptionData;

  const SubscriptionFeaturesSection({
    super.key,
    required this.subscriptionData,
  });

  @override
  Widget build(BuildContext context) {
    final features =
        (subscriptionData['features'] as List?)?.cast<Map<String, dynamic>>() ??
            [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        final isEnabled = feature['enabled'] == true;
        final label = feature['label'] ?? '';

        return Row(
          children: [
            Container(
              width: Sizes.s20,
              height: Sizes.s20,
              decoration: BoxDecoration(
                color: isEnabled
                    ? appColor(context)
                        .appTheme
                        .primary
                        .withValues(alpha: 0.12)
                    : appColor(context).appTheme.stroke.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEnabled ? Icons.check : Icons.close,
                size: Sizes.s12,
                color: isEnabled
                    ? appColor(context).appTheme.primary
                    : appColor(context).appTheme.lightText,
              ),
            ),
            HSpace(Sizes.s8),
            Expanded(
              child: TextWidgetCommon(
                text: label,
                style: AppCss.lexendRegular12.textColor(
                  isEnabled
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
