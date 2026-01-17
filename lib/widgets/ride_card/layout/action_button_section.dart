import '../../../config.dart';

class ActionButtonSection extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? leadingIcon;
  final bool showTrailingArrow;

  const ActionButtonSection({
    super.key,
    required this.label,
    required this.onTap,
    this.leadingIcon = Icons.person_add_outlined,
    this.showTrailingArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: Sizes.s12, vertical: Sizes.s10),
        decoration: BoxDecoration(
          color: appColor(context).appTheme.bgBox,
          borderRadius: BorderRadius.circular(Sizes.s8),
          border: Border.all(
            color: appColor(context).appTheme.stroke,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    size: Sizes.s20,
                    color: appColor(context).appTheme.primary,
                  ),
                  HSpace(Sizes.s10),
                ],
                TextWidgetCommon(
                  text: label,
                  fontSize: Sizes.s13,
                  fontWeight: FontWeight.w500,
                  color: appColor(context).appTheme.darkText,
                ),
              ],
            ),
            if (showTrailingArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: Sizes.s14,
                color: appColor(context).appTheme.lightText,
              ),
          ],
        ),
      ),
    );
  }
}
