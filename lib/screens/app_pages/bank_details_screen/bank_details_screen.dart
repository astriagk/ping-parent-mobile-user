import 'package:taxify_user_ui/config.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BankDetailsProvider>(builder: (context, bdCtrl, child) {
      return StatefulWrapper(
          onInit: () =>
              Future.delayed(DurationClass.ms50).then((value) => bdCtrl.init()),
          child: Scaffold(
              appBar: //common appBar layout
                  CommonAppBarLayout(
                      title: appFonts.bankDetails, radius: Sizes.s0),
              body: ListView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom / 5),
                  shrinkWrap: true,
                  children: [
                    Column(children: [
                      Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                            ////COMMON TEXT FIELD LAYOUT
                            BankDetailsWidgets().commonTextFieldLayout(context,
                                title: appFonts.bankName,
                                hintText: appFonts.enterBankName,
                                controller: bdCtrl.bankName),
                            //COMMON TEXT FIELD LAYOUT
                            BankDetailsWidgets().commonTextFieldLayout(context,
                                title: appFonts.holderName,
                                hintText: appFonts.enterHolderName,
                                controller: bdCtrl.holderName),
                            //COMMON TEXT FIELD LAYOUT
                            BankDetailsWidgets().commonTextFieldLayout(context,
                                title: appFonts.accountNo,
                                hintText: appFonts.enterAccountNo,
                                controller: bdCtrl.accountNo,
                                keyboardType: TextInputType.number),
                            //branch name title and dropdown layout
                            BankDetailsWidgets().branchDropDownLayout(),
                            //COMMON TEXT FIELD LAYOUT
                            BankDetailsWidgets().commonTextFieldLayout(context,
                                title: appFonts.ifscCode,
                                hintText: appFonts.ifscHint,
                                controller: bdCtrl.ifscCode),
                            //COMMON TEXT FIELD LAYOUT
                            BankDetailsWidgets()
                                .commonTextFieldLayout(context,
                                    title: appFonts.swiftCode,
                                    hintText: appFonts.swiftHint,
                                    controller: bdCtrl.swiftCode)
                                .padding(bottom: Sizes.s5)
                          ])
                          .padding(horizontal: Sizes.s20)
                          .authExtension(context),
                      VSpace(Sizes.s76),
                      CommonButton(
                              text: appFonts.update,
                              onTap: () => route.pop(context))
                          .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                    ])
                  ])));
    });
  }
}
