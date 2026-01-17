import '../config.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final Color statusColor;

  const StatusBadge({
    super.key,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s8, vertical: Sizes.s4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Sizes.s4),
      ),
      child: TextWidgetCommon(
        text: "• $status",
        fontSize: Sizes.s12,
        fontWeight: FontWeight.w500,
        color: statusColor,
      ),
    );
  }
}
