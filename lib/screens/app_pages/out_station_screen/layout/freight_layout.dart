import '../../../../config.dart';

class FreightLayout extends StatefulWidget {
  const FreightLayout({super.key});

  @override
  State<FreightLayout> createState() => _FreightLayoutState();
}

class _FreightLayoutState extends State<FreightLayout> {
  String? selectedVehicle;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(text: appFonts.vehicleType, fontWeight: FontWeight.w500)
          .padding(top: Sizes.s15, bottom: Sizes.s8),
      CommonDropDownMenu(
          bgColor: appTheme.bgBox,
          icon: SvgPicture.asset(svgAssets.arrowDown),
          svgIcon: svgAssets.arrowDown,
          isSVG: true,
          value: selectedVehicle,
          onChanged: (newValue) {
            setState(() {
              selectedVehicle = newValue; // Update the selected value
            });
          },
          hintText: appFonts.selectVehicleType,
          itemsList: [
            DropdownMenuItem<dynamic>(value: 'Bike', child: Text('Bike')),
            DropdownMenuItem<dynamic>(value: 'Car', child: Text('Car')),
            DropdownMenuItem<dynamic>(value: 'Auto', child: Text('Auto'))
          ]),
      TextWidgetCommon(text: appFonts.description, fontWeight: FontWeight.w500)
          .padding(top: Sizes.s15, bottom: Sizes.s8),
      TextFormField(
          maxLines: 3,
          decoration: InputDecoration(
              fillColor: appColor(context).appTheme.bgBox,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: Sizes.s8, cornerSmoothing: 2),
                  borderSide: BorderSide(
                      color: appColor(context).appTheme.trans,
                      width: Sizes.s2)),
              hintText: appFonts.forExample,
              hintStyle: AppCss.lexendLight12
                  .textColor(appColor(context).appTheme.lightText))),
      TextWidgetCommon(
              text: appFonts.pictureOfYourCargo, fontWeight: FontWeight.w500)
          .padding(top: Sizes.s15, bottom: Sizes.s8),
      DottedBorder(
              color: appColor(context).appTheme.lightText,
              radius: Radius.circular(Sizes.s6),
              strokeWidth: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(svgAssets.upload),
                    TextWidgetCommon(
                        text: appFonts.upload,
                        color: appColor(context).appTheme.lightText)
                  ]).center())
          .freightImageExtension(context),
    ]);
  }
}
