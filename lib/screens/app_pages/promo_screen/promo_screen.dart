import 'package:taxify_user_ui/config.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PromoProvider>(builder: (context, promoCtrl, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(DurationClass.ms150)
            .then((value) => promoCtrl.init()),
        child: Scaffold(
            appBar: CommonAppBarLayout(title: appFonts.promoCodeList),
            body: SingleChildScrollView(
                child: Column(
                        children: promoCtrl.promoList
                            .map((e) => Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                imageAssets.subtract),
                                            fit: BoxFit.fill)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //promo screen off and code layout
                                          PromoWidgets()
                                              .offAndCodeLayout(e, context),
                                          //promo screen fair price layout
                                          PromoWidgets()
                                              .fairPriceLayout(e, context),
                                          //promo screen date and useNow layout
                                          PromoWidgets()
                                              .dateAndUseNowLayout(context, e)
                                        ]).padding(all: Sizes.s15))
                                .paddingDirectional(
                                    bottom: Sizes.s15, horizontal: Sizes.s20))
                            .toList())
                    .paddingDirectional(top: Sizes.s25))),
      );
    });
  }
}
