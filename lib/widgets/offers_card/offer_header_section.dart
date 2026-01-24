import '../../config.dart';

class OfferHeaderSection extends StatelessWidget {
  final Map<String, dynamic> offerData;
  final int index;

  const OfferHeaderSection({
    super.key,
    required this.offerData,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(offerData['profile'],
                height: Sizes.s25, width: Sizes.s25),
            HSpace(Sizes.s6),
            TextWidgetCommon(text: offerData['title'])
          ],
        ),
        if (index == 0)
          IntrinsicHeight(
            child: Row(
              children: [
                VerticalDivider(
                    color: appColor(context).appTheme.stroke, thickness: 1),
                SvgPicture.asset(svgAssets.star),
                HSpace(Sizes.s6),
                TextWidgetCommon(
                    text: appFonts.rating,
                    style: AppCss.lexendMedium12
                        .textColor(appColor(context).appTheme.darkText)),
              ],
            ),
          ),
      ],
    );
  }
}
