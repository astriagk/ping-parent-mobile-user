import '../../config.dart';
import 'subscription_header_section.dart';
import 'subscription_price_section.dart';
import 'subscription_features_section.dart';
import 'subscription_kids_info.dart';
import 'subscription_badge_label.dart';

class SubscriptionCard extends StatelessWidget {
  final Map<String, dynamic> subscriptionData;
  final VoidCallback? onTap;
  final int kidCount;

  const SubscriptionCard({
    super.key,
    required this.subscriptionData,
    this.onTap,
    this.kidCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    final badge = subscriptionData['badge'] as Map<String, dynamic>?;
    final hasBadge =
        badge != null && (badge['text']?.toString().isNotEmpty ?? false);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(top: hasBadge ? Sizes.s12 : 0),
            decoration: BoxDecoration(
              color: appColor(context).appTheme.white,
              borderRadius: BorderRadius.circular(Sizes.s12),
              boxShadow: [
                BoxShadow(
                  color:
                      appColor(context).appTheme.primary.withValues(alpha: 0.04),
                  blurRadius: 12,
                  spreadRadius: 4,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubscriptionHeaderSection(subscriptionData: subscriptionData),
                SubscriptionPriceSection(
                  subscriptionData: subscriptionData,
                  kidCount: kidCount,
                ).padding(vertical: Sizes.s8),
                DottedLine(
                  alignment: WrapAlignment.center,
                  dashLength: 5.0,
                  dashGapLength: 2.0,
                  lineThickness: 1,
                  dashColor: appColor(context).appTheme.stroke,
                  direction: Axis.horizontal,
                ).padding(vertical: Sizes.s8),
                SubscriptionKidsInfo(subscriptionData: subscriptionData),
                SubscriptionFeaturesSection(subscriptionData: subscriptionData)
                    .padding(top: Sizes.s8),
              ],
            ).padding(all: Sizes.s12),
          ),
          // Badge positioned at top center
          if (hasBadge)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: SubscriptionBadgeLabel(badge: badge),
              ),
            ),
        ],
      ),
    );
  }
}
