import '../../config.dart';

class SubscriptionBadgeLabel extends StatelessWidget {
  final Map<String, dynamic>? badge;

  const SubscriptionBadgeLabel({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    if (badge == null) return const SizedBox.shrink();

    final text = badge!['text'] ?? '';
    final type = badge!['type'] ?? '';

    if (text.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.s12,
        vertical: Sizes.s6,
      ),
      decoration: BoxDecoration(
        color: _getBadgeColor(context, type),
        borderRadius: BorderRadius.circular(Sizes.s20),
      ),
      child: TextWidgetCommon(
        text: text,
        style: AppCss.lexendMedium12
            .textColor(appColor(context).appTheme.white),
      ),
    );
  }

  Color _getBadgeColor(BuildContext context, String type) {
    switch (type) {
      case 'best_value':
        return appColor(context).appTheme.primary;
      case 'popular':
        return appColor(context).appTheme.alertZone;
      case 'recommended':
        return appColor(context).appTheme.success;
      default:
        return appColor(context).appTheme.primary;
    }
  }
}
