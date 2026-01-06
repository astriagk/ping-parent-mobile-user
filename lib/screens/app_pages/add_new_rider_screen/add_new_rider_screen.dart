import 'package:taxify_user_ui/config.dart';

class AddNewRiderScreen extends StatelessWidget {
  const AddNewRiderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectRiderProvider>(builder: (context, riderCtrl, child) {
      return Scaffold(
          appBar: CommonAppBarLayout(title: appFonts.addNewRider),
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TextWidgetCommon(
                      text: appFonts.yourDeviceAddress,
                      color: appColor(context).appTheme.lightText,
                      textAlign: TextAlign.start,
                      fontSize: Sizes.s12,
                      fontWeight: FontWeight.w400),
                  TextWidgetCommon(
                          text: appFonts.firstName, fontWeight: FontWeight.w500)
                      .padding(top: Sizes.s25, bottom: Sizes.s8),
                  TextFieldCommon(
                      hintText: appFonts.enterYourFirstName,
                      color: appColor(context).appTheme.bgBox),
                  TextWidgetCommon(
                          text: appFonts.lastName, fontWeight: FontWeight.w500)
                      .padding(top: Sizes.s25, bottom: Sizes.s8),
                  TextFieldCommon(
                      hintText: appFonts.enterLastName,
                      color: appColor(context).appTheme.bgBox),
                  TextWidgetCommon(
                          text: appFonts.phoneNumber,
                          fontWeight: FontWeight.w500)
                      .padding(top: Sizes.s25, bottom: Sizes.s8),
                  CountryPickerLayout(
                      textFieldColor: appColor(context).appTheme.bgBox)
                ])
              ]).padding(horizontal: Sizes.s20, vertical: Sizes.s20)),
          bottomNavigationBar: Padding(
              padding: EdgeInsets.all(Sizes.s20),
              child: CommonButton(text: appFonts.addRider)
                  .inkWell(onTap: () => riderCtrl.addRider(context))));
    });
  }
}
