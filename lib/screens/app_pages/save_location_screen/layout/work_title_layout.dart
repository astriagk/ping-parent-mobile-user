import '../../../../config.dart';

//ICON WORK OR HOME EDIT AND DELETE LAYOUT
class WorkTitleLayout extends StatelessWidget {
  final dynamic e;

  const WorkTitleLayout({super.key, this.e});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Address type icon + label
        Row(children: [
          Container(
            height: Sizes.s40,
            width: Sizes.s40,
            decoration: BoxDecoration(
              color: appColor(context).appTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Sizes.s10),
            ),
            child: Center(
              child: SvgPicture.asset(
                e['icon'] ?? svgAssets.home,
                height: Sizes.s20,
                width: Sizes.s20,
                colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          HSpace(Sizes.s12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidgetCommon(
                text: e['title'] ?? '',
                style: AppCss.lexendMedium14
                    .textColor(appColor(context).appTheme.darkText),
              ),
              VSpace(Sizes.s2),
              TextWidgetCommon(
                text: 'Primary address',
                style: AppCss.lexendRegular12
                    .textColor(appColor(context).appTheme.lightText),
              ),
            ],
          ),
        ]),

        // Edit button
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => route.pushNamed(context, routeName.addLocationScreen),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Sizes.s10, vertical: Sizes.s6),
            decoration: BoxDecoration(
              border: Border.all(
                color: appColor(context).appTheme.stroke,
              ),
              borderRadius: BorderRadius.circular(Sizes.s20),
            ),
            child: Row(children: [
              SvgPicture.asset(
                svgAssets.edit,
                height: Sizes.s14,
                width: Sizes.s14,
                colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              HSpace(Sizes.s5),
              TextWidgetCommon(
                text: appFonts.change,
                style: AppCss.lexendMedium12
                    .textColor(appColor(context).appTheme.primary),
              ),
            ]),
          ),
        ),
      ],
    ).padding(all: Sizes.s15);
  }
}
