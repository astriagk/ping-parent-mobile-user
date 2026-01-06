import 'package:taxify_user_ui/config.dart';

class CommonAppBarLayout extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final String? suffixIcon;
  final double? radius, padding;
  final bool? icon;
  final GestureTapCallback? onTap;
  final Widget? child;
  final Color? color;
  final TextStyle? titleStyle;

  const CommonAppBarLayout(
      {super.key,
      this.title,
      this.radius,
      this.icon,
      this.suffixIcon,
      this.onTap,
      this.child,
      this.padding,
      this.color,
      this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: const SizedBox.shrink(),
        shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.only(
                bottomRight: SmoothRadius(
                    cornerRadius: radius ?? Sizes.s20, cornerSmoothing: 1),
                bottomLeft: SmoothRadius(
                    cornerRadius: radius ?? Sizes.s20, cornerSmoothing: 1))),
        titleSpacing: 0,
        leadingWidth: 0,
        backgroundColor: color ?? appColor(context).appTheme.bgBox,
        flexibleSpace:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CommonIconButton(
                icon: svgAssets.back, onTap: () => route.pop(context)),
            TextWidgetCommon(
                text: title,
                textAlign: TextAlign.center,
                style: titleStyle ??
                    AppCss.lexendSemiBold20
                        .textColor(appColor(context).appTheme.darkText)),
            icon == true
                ? CommonIconButton(icon: suffixIcon, onTap: onTap)
                : Container(child: child)
                    .paddingDirectional(horizontal: padding ?? Sizes.s20)
          ]).padding(horizontal: Sizes.s20)
        ]).padding(vertical: Sizes.s30));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(90);
}
