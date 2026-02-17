import '../../config.dart';

class SubscriptionBadgeLabel extends StatelessWidget {
  final String text;
  final String type;

  const SubscriptionBadgeLabel({
    super.key,
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
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
      case 'current':
        return appColor(context).appTheme.success;
      case 'upgrade':
        return appColor(context).appTheme.yellowIcon;
      default:
        return appColor(context).appTheme.primary;
    }
  }
}
