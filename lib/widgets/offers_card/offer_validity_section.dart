import '../../config.dart';

class OfferValiditySection extends StatelessWidget {
  final Map<String, dynamic> offerData;

  const OfferValiditySection({
    super.key,
    required this.offerData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidgetCommon(
          text: appFonts.validTill,
          style: AppCss.lexendRegular11
              .textColor(appColor(context).appTheme.lightText),
        ),
        TextWidgetCommon(
            text: ": ${offerData['Valid till']}",
            style: AppCss.lexendRegular11
                .textColor(appColor(context).appTheme.lightText))
      ],
    );
  }
}
