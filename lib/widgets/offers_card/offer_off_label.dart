import '../../config.dart';

class OfferOffLabel extends StatelessWidget {
  const OfferOffLabel({super.key});

  @override
  Widget build(BuildContext context) {
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
