import 'package:taxify_user_ui/screens/app_pages/out_station_screen/layout/out_station_widgets.dart';

import '../../../../config.dart';

//offer and payment method layout
class OfferPaymentLayout extends StatelessWidget {
  final TextEditingController? price;
  final Color? bgColor;
  final Color? textColor;
  final bool? payment;
  final GestureTapCallback? onTap;
  final GestureTapCallback? paymentOnTap;

  const OfferPaymentLayout(
      {super.key,
      this.price,
      this.bgColor,
      this.textColor,
      this.onTap,
      this.payment,
      this.paymentOnTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectRiderProvider>(builder: (context, riderCtrl, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextWidgetCommon(
            style: AppCss.lexendMedium14,
            text: appFonts.offerYourFare,
            fontWeight: FontWeight.w500),
        VSpace(Sizes.s8),
        TextFieldCommon(
            controller: price,
            hintText: appFonts.enterFareAmount,
            prefixIcon: SvgPicture.asset(svgAssets.dollarCircle)
                .padding(vertical: Sizes.s16, left: Insets.i10),
            color: appColor(context).appTheme.bgBox),
        TextWidgetCommon(
                style: AppCss.lexendMedium14,
                text: appFonts.paymentMethod,
                fontWeight: FontWeight.w500)
            .padding(bottom: Sizes.s8, top: Sizes.s20),
        OutStationWidgets().commonPaymentLayout(context,
            isSelect: payment, onTap: paymentOnTap),
        CommonButton(
                bgColor: bgColor,
                text: appFonts.bookRide,
                textColor: textColor,
                onTap: onTap)
            .padding(top: Sizes.s20)
      ]).offerFareExtension(context);
    });
  }
}
