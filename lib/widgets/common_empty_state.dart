import '../config.dart';

class CommonEmptyState extends StatelessWidget {
  final String? title;
  final String? image;
  final String mainText;
  final String descriptionText;
  final String buttonText;
  final VoidCallback onButtonTap;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const CommonEmptyState({
    super.key,
    this.title,
    this.image,
    required this.mainText,
    required this.descriptionText,
    required this.buttonText,
    required this.onButtonTap,
    this.showBackButton = false,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.zero, children: [
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        // Header section with curved design
        if (title != null || showBackButton)
          Container(
              decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.only(
                          bottomRight: SmoothRadius(
                              cornerRadius: Sizes.s102, cornerSmoothing: 1))),
                  color: appColor(context).appTheme.bgBox),
              child: Column(children: [
                VSpace(Sizes.s58),
                if (title != null || showBackButton)
                  Row(children: [
                    HSpace(Sizes.s20),
                    if (showBackButton)
                      CommonIconButton(
                          icon: svgAssets.back,
                          onTap: onBackTap ?? () => route.pop(context)),
                    if (showBackButton && title != null) HSpace(Sizes.s70),
                    if (title != null)
                      TextWidgetCommon(
                          text: title!,
                          style:
                              AppCss.lexendMedium18.textColor(appTheme.primary))
                  ]),
                Image.asset(image ?? imageAssets.empty).padding(
                    vertical: Sizes.s30, right: Sizes.s58, left: Sizes.s90)
              ])).paddingOnly(right: Sizes.s30),

        // Image only (without header)
        if (title == null && !showBackButton)
          Image.asset(image ?? imageAssets.empty)
              .padding(vertical: Sizes.s30, horizontal: Sizes.s40),

        // Content section
        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextWidgetCommon(
              text: mainText,
              style: AppCss.lexendSemiBold18
                  .textColor(appColor(context).appTheme.darkText)),
          VSpace(Sizes.s8),
          TextWidgetCommon(
                  text: descriptionText,
                  style: AppCss.lexendRegular12
                      .textColor(appColor(context).appTheme.lightText)
                      .textHeight(1.2),
                  textAlign: TextAlign.center)
              .padding(horizontal: Sizes.s15),
          CommonButton(text: buttonText, onTap: onButtonTap)
              .padding(bottom: Sizes.s30, top: Sizes.s40)
        ]).padding(horizontal: Sizes.s20, top: Sizes.s20)
      ])
    ]);
  }
}
