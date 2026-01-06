import '../../../../../config.dart';

class TextFieldLayout extends StatelessWidget {
  const TextFieldLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddLocationProvider>(
        builder: (context, locationCtrl, child) {
      return Expanded(
          child: ListView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  shrinkWrap: true,
                  children: [
            //common title and text-field layout
            LocationWidgets().commonTextFields(context,
                title: appFonts.street,
                controller: locationCtrl.streetCtrl,
                hintText: appFonts.street,
                icon: svgAssets.routing),
            //common title
            TextWidgetCommon(text: appFonts.country),
            //country dropdown
            CommonDropDownMenu(
                    isSVG: false,
                    svgIcon: svgAssets.global,
                    value: locationCtrl.country,
                    onChanged: (newValue) =>
                        locationCtrl.countryChange(newValue),
                    hintText: appFonts.country,
                    itemsList: locationCtrl.countryDialogDropDownItems
                        .map((item) => DropdownMenuItem<dynamic>(
                            value: item['value'],
                            child: TextWidgetCommon(text: item['label'])))
                        .toList())
                .padding(top: Sizes.s8, bottom: Sizes.s20),
            //common title
            TextWidgetCommon(text: appFonts.state),
            //state dropdown
            CommonDropDownMenu(
                    isSVG: false,
                    svgIcon: svgAssets.global,
                    value: locationCtrl.state,
                    onChanged: (newValue) => locationCtrl.stateChange(newValue),
                    hintText: appFonts.state,
                    itemsList: locationCtrl.dialogDropDownItems
                        .map((item) => DropdownMenuItem<dynamic>(
                            value: item['value'],
                            child: TextWidgetCommon(text: item['label'])))
                        .toList())
                .padding(top: Sizes.s8, bottom: Sizes.s20),
            //common title and text-field layout
            LocationWidgets().commonTextFields(context,
                title: appFonts.area,
                controller: locationCtrl.areaCtrl,
                hintText: appFonts.area,
                icon: svgAssets.location),
            //common title and text-field layout
            LocationWidgets().commonTextFields(context,
                title: appFonts.city,
                controller: locationCtrl.cityCtrl,
                hintText: appFonts.city,
                icon: svgAssets.location),
            //common title and text-field layout
            LocationWidgets()
                .commonTextFields(context,
                    title: appFonts.zip,
                    controller: locationCtrl.zipCtrl,
                    hintText: appFonts.zip,
                    icon: svgAssets.gps)
                .padding(bottom: Insets.i40)
          ])
              .paddingOnly(bottom: Sizes.s30)
              .width(MediaQuery.of(context).size.width)
              .padding(horizontal: Sizes.s20, vertical: Sizes.s25)
              .decorated(
                  tRRadius: Sizes.s20,
                  tLRadius: Sizes.s20,
                  color: appColor(context).appTheme.bgBox));
    });
  }
}

class KeyValueModel {
  String itemName;
  String itemId;

  KeyValueModel({required this.itemName, required this.itemId});
}
