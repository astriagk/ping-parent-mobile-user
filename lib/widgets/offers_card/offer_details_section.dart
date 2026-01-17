import '../../config.dart';

class OfferDetailsSection extends StatelessWidget {
  final Map<String, dynamic> offerData;

  const OfferDetailsSection({
    super.key,
    required this.offerData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidgetCommon(
            text: offerData['area'],
            style: AppCss.lexendRegular12
                .textColor(appColor(context).appTheme.darkText)),
        VSpace(Sizes.s6),
        IntrinsicHeight(
          child: Row(
            children: [
              SvgPicture.asset(svgAssets.car),
              HSpace(Sizes.s6),
              TextWidgetCommon(
                text: offerData['car'],
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
                  text: offerData['person'],
                  style: AppCss.lexendLight11
                      .textColor(appColor(context).appTheme.darkText))
            ],
          ),
        ),
        VSpace(Sizes.s13),
      ],
    );
  }
}
