import 'package:taxify_user_ui/config.dart';

class SelectRiderScreen extends StatelessWidget {
  const SelectRiderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectRiderProvider>(builder: (context, riderCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => riderCtrl.onInit()),
          child: Scaffold(
              body: Stack(children: [
            AddLocationWidgets().googleMapLayout(),
            CommonIconButton(
                icon: svgAssets.back,
                onTap: () => riderCtrl.isInfo
                    ? riderCtrl.onBackInfo()
                    : riderCtrl.isBookNow
                        ? riderCtrl.onBackPayment(context)
                        : riderCtrl.mainBack(context)).padding(all: Sizes.s20),
            Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: riderCtrl.isInfo
                          ? const InfoLayout()
                          : riderCtrl.isBookNow
                              ? const LoadingDriverLayout()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidgetCommon(
                                                text: appFonts.vehicleType,
                                                fontWeight: FontWeight.w500),
                                            VSpace(Sizes.s15),
                                            //vehicle type layout
                                            SelectRiderWidgets()
                                                .vehicleType(isRental: false)
                                          ]).paddingDirectional(
                                          horizontal: Sizes.s20),
                                      VSpace(Sizes.s15),
                                      //offer and payment method layout
                                      OfferPaymentLayout(
                                              payment: riderCtrl.isPayment,
                                              paymentOnTap: () => riderCtrl
                                                  .selectPayment(),
                                              price: riderCtrl.price,
                                              onTap:
                                                  () => riderCtrl
                                                      .bookNowOnTap(),
                                              textColor:
                                                  riderCtrl.price.text
                                                              .isEmpty ||
                                                          riderCtrl
                                                                  .selectedIndex ==
                                                              null ||
                                                          riderCtrl.isPayment ==
                                                              false
                                                      ? appColor(context)
                                                          .appTheme
                                                          .lightText
                                                      : appColor(
                                                              context)
                                                          .appTheme
                                                          .white,
                                              bgColor: riderCtrl
                                                          .price.text.isEmpty ||
                                                      riderCtrl.selectedIndex ==
                                                          null ||
                                                      riderCtrl.isPayment ==
                                                          false
                                                  ? appColor(context)
                                                      .appTheme
                                                      .bgBox
                                                  : appColor(context)
                                                      .appTheme
                                                      .primary)
                                          .paddingDirectional(all: Sizes.s20)
                                          .offerFareExtension(context)
                                    ]).riderScreenBg(context))
                ])
          ])));
    });
  }
}
