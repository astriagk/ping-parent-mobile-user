import '../../../../config.dart';

class HomeWidgets {
  // ,profile,title
  Widget offerTitleProfileRating(e, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(e.value['profile'],
                height: Sizes.s25, width: Sizes.s25),
            HSpace(Sizes.s6),
            TextWidgetCommon(text: e.value['title'])
          ],
        ),
        if (e.key == 0)
          IntrinsicHeight(
              child: Row(children: [
            VerticalDivider(
                color: appColor(context).appTheme.stroke, thickness: 1),
            SvgPicture.asset(svgAssets.star),
            HSpace(Sizes.s6),
            TextWidgetCommon(
                text: appFonts.rating,
                style: AppCss.lexendMedium12
                    .textColor(appColor(context).appTheme.darkText)),
          ])),
      ],
    );
  } // dotted line layout

  Widget dottedLineLayout(context) {
    return DottedLine(
            alignment: WrapAlignment.center,
            dashLength: 5.0,
            dashGapLength: 2.0,
            lineThickness: 1,
            dashColor: appColor(context).appTheme.stroke,
            direction: Axis.horizontal)
        .padding(vertical: Sizes.s8);
  }

  Widget offerAreaCarPersonLayout(e, context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgetCommon(
              text: e.value['area'],
              style: AppCss.lexendRegular12
                  .textColor(appColor(context).appTheme.darkText)),
          VSpace(Sizes.s6),
          IntrinsicHeight(
              child: Row(children: [
            SvgPicture.asset(svgAssets.car),
            HSpace(Sizes.s6),
            TextWidgetCommon(
              text: e.value['car'],
              style: AppCss.lexendLight11
                  .textColor(appColor(context).appTheme.darkText),
            ),
            HSpace(Sizes.s8),
            VerticalDivider(
              indent: Sizes.s2,
              color: appColor(context).appTheme.lightText,
              width: 0,
            ),
            HSpace(Sizes.s6),
            SvgPicture.asset(svgAssets.person),
            HSpace(Sizes.s6),
            TextWidgetCommon(
                text: e.value['person'],
                style: AppCss.lexendLight11
                    .textColor(appColor(context).appTheme.darkText))
          ])),
          VSpace(Sizes.s13),
        ]);
  }

  Widget validTillDate(context, e) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextWidgetCommon(
        text: appFonts.validTill,
        style: AppCss.lexendRegular11
            .textColor(appColor(context).appTheme.lightText),
      ),
      TextWidgetCommon(
          text: ": ${e.value['Valid till']}",
          style: AppCss.lexendRegular11
              .textColor(appColor(context).appTheme.lightText))
    ]);
  }

  Widget offerImageOffLayout(context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(imageAssets.offerBG), fit: BoxFit.fill)),
        child: RotatedBox(
                quarterTurns: 3,
                child: TextWidgetCommon(
                    text: appFonts.off,
                    style: AppCss.lexendSemiBold18
                        .textColor(appColor(context).appTheme.darkText)))
            .padding(horizontal: Sizes.s21, vertical: Sizes.s24));
  }
}
