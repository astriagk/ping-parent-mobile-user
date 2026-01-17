import '../../../../config.dart';
import '../../../../widgets/offers_card/offers_card.dart';

class TodayOfferLayout extends StatelessWidget {
  const TodayOfferLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, homeCtrl, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgetCommon(
                  text: appFonts.todayOffer,
                  style: AppCss.lexendMedium18
                      .textColor(appColor(context).appTheme.darkText))
              .padding(top: Sizes.s25, bottom: Sizes.s15),
          Column(
              children: homeCtrl.offer
                  .asMap()
                  .entries
                  .map((e) => OffersCard(
                        offerData: e.value,
                        index: e.key,
                      ).paddingOnly(bottom: Sizes.s15))
                  .toList())
        ],
      );
    });
  }
}
