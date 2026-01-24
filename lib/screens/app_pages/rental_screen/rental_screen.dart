import 'package:taxify_user_ui/config.dart';

class RentalScreen extends StatelessWidget {
  const RentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RentalProvider>(builder: (context, rentalCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => rentalCtrl.onInit()),
          child: Scaffold(
              body: Stack(children: [
            AddLocationWidgets().mapLayout(),
            Positioned(top: 40, right: 20, child: CommonSwitchRider()),
            CommonIconButton(
                icon: svgAssets.back,
                onTap: () {
                  rentalCtrl.isPayment = false;
                  rentalCtrl.price.text.isEmpty;
                  rentalCtrl.selectedIndex = null;
                  rentalCtrl.hourSelectedIndex = null;
                  // rentalCtrl.notifyListeners(); // Removed: Only call within provider
                  route.pop(context);
                }).padding(horizontal: Sizes.s20, vertical: Sizes.s30),
            Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Row(children: [
                              TextWidgetCommon(
                                  text: appFonts.chooseAPackage,
                                  fontWeight: FontWeight.w500),
                              HSpace(Insets.i4),
                              SvgPicture.asset(svgAssets.infoCircle)
                            ]),
                            const ChoosePackageListLayout()
                                .padding(bottom: Sizes.s20, top: Sizes.s10),
                            if (rentalCtrl.hourSelectedIndex == null)
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidgetCommon(
                                            text: appFonts
                                                .multipleStopsTopDrivers,
                                            fontSize: Sizes.s12,
                                            textAlign: TextAlign.center,
                                            color: appColor(context)
                                                .appTheme
                                                .success,
                                            fontWeight: FontWeight.w500)
                                        .padding(
                                            horizontal: Sizes.s34,
                                            vertical: Sizes.s15)
                                        .decorated(
                                            color: appColor(context)
                                                .appTheme
                                                .success
                                                .withValues(alpha: 0.10),
                                            allRadius: Sizes.s8)
                                        .padding(bottom: Sizes.s20),
                                    CommonButton(
                                        margin:
                                            EdgeInsets.only(bottom: Insets.i20),
                                        bgColor:
                                            appColor(context).appTheme.stroke,
                                        text: appFonts.bookRide,
                                        textColor: appColor(context)
                                            .appTheme
                                            .lightText)
                                  ])
                          ])
                          .paddingDirectional(
                              horizontal: Sizes.s20, top: Sizes.s20)
                          .decorated(
                              tLRadius: Sizes.s20,
                              tRRadius: Sizes.s20,
                              color: rentalCtrl.hourSelectedIndex != null
                                  ? appColor(context).appTheme.bgBox
                                  : appColor(context).appTheme.white),
                      if (rentalCtrl.hourSelectedIndex != null)
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidgetCommon(
                                        style: AppCss.lexendMedium14,
                                        text: appFonts.vehicleType),
                                    VSpace(Sizes.s12),
                                    SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: IntrinsicHeight(
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: rentalCtrl.vehicleType
                                                    .asMap()
                                                    .entries
                                                    .map(
                                                        (e) => //vehicle type image ,time, fareAway,title layout
                                                            VehicleTypeLayout(
                                                                infoOnTap: () =>
                                                                    rentalCtrl.infoOnTap(
                                                                        e.key,
                                                                        context),
                                                                onTap: () =>
                                                                    rentalCtrl.onTap(
                                                                        e.key),
                                                                isRental: true,
                                                                e: e,
                                                                sideColor: e.key ==
                                                                        rentalCtrl
                                                                            .selectedIndex
                                                                    ? appColor(context)
                                                                        .appTheme
                                                                        .primary
                                                                    : appColor(
                                                                            context)
                                                                        .appTheme
                                                                        .trans))
                                                    .toList()))),
                                    //common label Minimum price for this fare.. text layout
                                    OutStationWidgets()
                                        .commonLabelDesign(context)
                                        .marginSymmetric(horizontal: 20),
                                  ]).padding(horizontal: Sizes.s20),
                              OfferPaymentLayout(
                                payment: rentalCtrl.isPayment,
                                paymentOnTap: () => rentalCtrl.selectPayment(),
                                onTap: () => route.pushNamed(
                                    context, routeName.findingDriverScreen),
                                bgColor: rentalCtrl.price.text.isEmpty ||
                                        rentalCtrl.selectedIndex == null ||
                                        rentalCtrl.isPayment == false
                                    ? appColor(context).appTheme.bgBox
                                    : appColor(context).appTheme.primary,
                                textColor: rentalCtrl.price.text.isEmpty ||
                                        rentalCtrl.selectedIndex == null ||
                                        rentalCtrl.isPayment == false
                                    ? appColor(context).appTheme.lightText
                                    : appColor(context).appTheme.white,
                                price: rentalCtrl.price,
                              ).padding(all: Sizes.s15).decorated(
                                  tRRadius: Sizes.s20,
                                  tLRadius: Sizes.s20,
                                  color: appColor(context).appTheme.white)
                            ]).backgroundColor(
                            rentalCtrl.hourSelectedIndex != null
                                ? appColor(context).appTheme.bgBox
                                : appColor(context).appTheme.white)
                    ]).rentalScreenExtension(context)))
          ])));
    });
  }
}
