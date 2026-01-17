import '../../config.dart';

class SubscriptionPriceSection extends StatelessWidget {
  final Map<String, dynamic> subscriptionData;
  final int kidCount;

  const SubscriptionPriceSection({
    super.key,
    required this.subscriptionData,
    this.kidCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    final currency = subscriptionData['currency'] ?? 'INR';
    final basePrice = subscriptionData['price'] ?? 0;
    final kids = subscriptionData['kids'] as Map<String, dynamic>?;
    final maxKids = kids?['max'] ?? 1;

    // Calculate total price: if plan supports only 1 kid and parent has multiple kids
    final int multiplier = maxKids == 1 && kidCount > 1 ? kidCount : 1;
    final totalPrice = basePrice * multiplier;
    final showMultiplier = multiplier > 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextWidgetCommon(
          text: currency == 'INR' ? '₹' : currency,
          style: AppCss.lexendSemiBold24
              .textColor(appColor(context).appTheme.primary),
        ),
        HSpace(Sizes.s4),
        TextWidgetCommon(
          text: totalPrice.toString(),
          style: AppCss.lexendSemiBold24
              .textColor(appColor(context).appTheme.primary),
        ),
        HSpace(Sizes.s6),
        TextWidgetCommon(
          text: '/${subscriptionData['plan_type'] ?? 'month'}',
          style: AppCss.lexendRegular12
              .textColor(appColor(context).appTheme.lightText),
        ).paddingOnly(bottom: Sizes.s4),
        if (showMultiplier) ...[
          HSpace(Sizes.s8),
          TextWidgetCommon(
            text: '(₹$basePrice × $kidCount kids)',
            style: AppCss.lexendRegular11
                .textColor(appColor(context).appTheme.lightText),
          ).paddingOnly(bottom: Sizes.s4),
        ],
      ],
    );
  }
}
