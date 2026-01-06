import 'package:taxify_user_ui/screens/app_pages/my_wallet_screen/layouts/home_screen_widget.dart';
import 'package:taxify_user_ui/widgets/common_app_bar_layout1.dart';

import '../../../../config.dart';
import '../../../../widgets/common_bg_layout.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBarLayout1(
            title: language(context, "Withdraw"),
            titleWidth: MediaQuery.of(context).size.width * 0.02),
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Text(language(context, appFonts.bankDetails),
                    style: AppCss.lexendBold16.textColor(appTheme.primary)),
                VSpace(Insets.i15),
                CommonBgLayout(
                    child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language(context, "Ac No."),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.hintTextClr)),
                        Text(language(context, "1256 2635 8956"),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.hintTextClr))
                      ]),
                  VSpace(Insets.i12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language(context, "Ifsc"),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.hintTextClr)),
                        Text(language(context, "DBSS0IN0000"),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.hintTextClr))
                      ]),
                  VSpace(Insets.i12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language(context, appFonts.bankName),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.hintTextClr)),
                        Text(language(context, "DBS Bank"),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.hintTextClr))
                      ]),
                  VSpace(Insets.i12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language(context, "Name"),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.hintTextClr)),
                        Text(language(context, "Zain dorwart"),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.hintTextClr))
                      ])
                ])),
                HomeScreenWidget().dottedLineCommon(
                    vertical: Insets.i20, dashColor: appTheme.stroke),
                Text(language(context, "Add Withdraw Amount"),
                    style: AppCss.lexendBold16.textColor(appTheme.primary)),
                VSpace(Insets.i15),
                AuthCommonWidgets().textAndTextField1(
                    language(context, "Enter Amount"),
                    language(context, "Enter Withdraw Amount"),
                    context,
                    titleColor: appTheme.hintTextClr,
                    fieldBgColor: appTheme.bgBox,
                    prefixIcon: SvgPicture.asset(svgAssets.dollarCircle)
                        .padding(vertical: Insets.i15),
                    style: AppCss.lexendRegular14
                        .textColor(appColor(context).appTheme.hintText),
                    keyboardType: TextInputType.number)
              ]))),
          CommonButton(
              text: language(context, "Withdraw"),
              onTap: () => route.pop(context))
        ]).marginSymmetric(vertical: Insets.i25, horizontal: Insets.i20));
  }
}
