import '../../../../config.dart';

class CountryPickerLayout extends StatelessWidget {
  final Color? textFieldColor;
  final TextEditingController? controller;

  const CountryPickerLayout({super.key, this.controller, this.textFieldColor});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInProvider>(builder: (context, value, child) {
      return Row(children: [
        CountryListPickCustom(
                appBar: AppBar(
                    centerTitle: true,
                    title: TextWidgetCommon(
                        color: Colors.green,
                        text: "Select Country",
                        style: AppCss.lexendMedium20
                            .textColor(appColor(context).appTheme.white)),
                    elevation: 0,
                    backgroundColor: appTheme.primary),
                theme: CountryTheme(
                    selectedItemTextStyle: TextStyle(color: Colors.green),
                    isShowFlag: false,
                    isShowTitle: false,
                    isShowCode: true,
                    isDownIcon: true,
                    showEnglishName: true,
                    alphabetTextColor: appColor(context).appTheme.darkText,
                    labelColor: appColor(context).appTheme.lightText,
                    alphabetSelectedBackgroundColor: appTheme.yellowIcon),
                initialSelection: '+91',
                onChanged: (CountryCodeCustom? code) {
                  value.countryCode = code!.dialCode!;
                  value.onCountryCode(value.countryCode);
                },
                useUiOverlay: true,
                useSafeArea: true)
            .padding(all: 0, vertical: Sizes.s4)
            .decorated(
                allRadius: Sizes.s8,
                color: textFieldColor ?? appColor(context).appTheme.screenBg),
        HSpace(Sizes.s8),
        TextFieldCommon(
                controller: controller,
                hintText: appFonts.enterYourNumber,
                color: textFieldColor ?? appColor(context).appTheme.white,
                keyboardType: TextInputType.number)
            .decorated(
                allRadius: Sizes.s8, color: appColor(context).appTheme.screenBg)
            .expanded(flex: 4)
      ]).padding(top: Sizes.s9, bottom: Sizes.s60);
    });
  }
}
