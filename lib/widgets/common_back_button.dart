import 'package:taxify_user_ui/config.dart';

//common back button
class CommonIconButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String? icon;
  final Color? bgColor;
  final double? height;
  final double? width;
  final double? iconHeight;
  final double? iconWidth;
  final bool? isImage;
  final String? imageIcon;
  final ColorFilter? iconColor;

  const CommonIconButton(
      {super.key,
      this.onTap,
      this.icon,
      this.bgColor,
      this.height,
      this.width,
      this.iconHeight,
      this.iconWidth,
      this.imageIcon,
      this.isImage,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? Sizes.s40,
        width: width ?? Sizes.s40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor ?? appColor(context).appTheme.white),
        child: isImage == true
            ? Image.asset(icon!, fit: BoxFit.fill)
            : SvgPicture.asset(icon!,
                    width: iconWidth ?? Sizes.s22,
                    colorFilter: iconColor,
                    //     ColorFilter.mode(appTheme.white, BlendMode.srcIn),
                    height: iconHeight ?? Sizes.s22,
                    fit: BoxFit.scaleDown)
                .inkWell(onTap: onTap));
  }
}
