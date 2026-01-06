import '../config.dart';

class CommonArrow extends StatelessWidget {
  final String? arrow;

  final Color? color, svgColor, bgColor;
  final GestureTapCallback? onTap;

  const CommonArrow(
      {super.key,
      this.arrow,
      this.color,
      this.svgColor,
      this.onTap,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(arrow!,
            fit: BoxFit.scaleDown,
            colorFilter: ColorFilter.mode(
                svgColor ?? appColor(context).appTheme.darkText,
                BlendMode.srcIn))
        .padding(all: Sizes.s8)
        .backButtonBorderExtension(context, bgColor: bgColor)
        .inkWell(onTap: onTap);
  }
}
