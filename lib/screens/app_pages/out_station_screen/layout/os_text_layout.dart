import '../../../../config.dart';

//outstation all text and changes text layout
class OutStationTextLayout extends StatelessWidget {
  const OutStationTextLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OutStationProvider>(builder: (context, outCtrl, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextWidgetCommon(
                text: appFonts.dateAndTime, fontWeight: FontWeight.w500)
            .padding(top: Sizes.s15, bottom: Sizes.s8),
        TextFieldCommon(
            hintText: appFonts.selectDateAndTime,
            color: appColor(context).appTheme.bgBox,
            suffixIcon:
                SvgPicture.asset(svgAssets.calendar, fit: BoxFit.scaleDown)
                    .inkWell(onTap: () => outCtrl.dateTime(context))),
        if (outCtrl.selectedOptionIndex == null)
          //number of passenger and Enter total passenger dropdown layout
          OutStationWidgets().numberOfPassenger(),
        if (outCtrl.selectedOptionIndex != null)
          outCtrl.data['title'] == appFonts.parcel
              ? const ParcelLayout()
              : outCtrl.data['title'] == appFonts.freight
                  ? const FreightLayout()
                  : //number of passenger and Enter total passenger  dropdown layout
                  OutStationWidgets().numberOfPassenger(),
        //common text layout
        OutStationWidgets().commonTextLayout(context,
            title: appFonts.enterYourOfferRate,
            hintText: appFonts.enterFareAmount),
        if (outCtrl.selectedOptionIndex == null)
          //common text layout
          OutStationWidgets().commonTextLayout(context,
              title: appFonts.comments, hintText: appFonts.enterYourComments),
        if (outCtrl.selectedOptionIndex != null)
          outCtrl.data['title'] == appFonts.parcel ||
                  outCtrl.data['title'] == appFonts.freight
              ? const SizedBox.shrink()
              : //common text layout
              OutStationWidgets().commonTextLayout(context,
                  title: appFonts.comments,
                  hintText: appFonts.enterYourComments),
        //select payment method text layout
        OutStationWidgets().paymentLayout(context)
      ]).padding(horizontal: Sizes.s20);
    });
  }
}
