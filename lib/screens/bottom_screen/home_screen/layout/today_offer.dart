import '../../../../config.dart';

class TodayOfferLayout extends StatelessWidget {
  const TodayOfferLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, homeCtrl, child)  {
        return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [TextWidgetCommon(
            text: appFonts.todayOffer,
            style: AppCss.lexendMedium18
                .textColor(appColor(context).appTheme.darkText))
            .padding(top: Sizes.s25, bottom: Sizes.s15),
          Column(
              children: homeCtrl.offer
                  .asMap()
                  .entries
                  .map((e) => Row(children: [
                HomeWidgets()
                    .offerImageOffLayout(context)
                    .paddingDirectional(all: Sizes.s8),
                Expanded(
                  child: Column(children: [
                    HomeWidgets()
                        .offerTitleProfileRating(e, context),
                    HomeWidgets().dottedLineLayout(context),
                    HomeWidgets()
                        .offerAreaCarPersonLayout(e, context),
                    HomeWidgets().validTillDate(context, e),
                  ]).padding(right: Sizes.s15),
                ),
              ])
                  .offerExtension(context)
                  .paddingOnly(bottom: Sizes.s15))
                  .toList())],);
      }
    );
  }
}
