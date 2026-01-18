import '../../../config.dart';
import '../../../provider/app_pages_providers/my_wallet_provider.dart';
import '../../../widgets/common_app_bar_layout1.dart';
import '../../../widgets/common_bg_layout.dart';

class MyWalletScreen extends StatelessWidget {
  const MyWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyWalletProvider>(builder: (context, myWalletPvr, child) {
      return Scaffold(
          appBar: CommonAppBarLayout1(
              title: language(context, "My Wallet"),
              titleWidth: MediaQuery.of(context).size.width * 0.01),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(alignment: Alignment.centerLeft, children: [
                  Image.asset('assets/image/setting/my_wallet.png',
                      width: double.infinity),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language(context, "Total Balance"),
                                  style: AppCss.lexendRegular12
                                      .textColor(appTheme.onBoardTxtClr)),
                              VSpace(Insets.i4),
                              Text("\$${language(context, "2300.99")}",
                                  style: AppCss.lexendBold16
                                      .textColor(appTheme.white))
                            ]),
                        Container(
                                alignment: Alignment.center,
                                height: Insets.i36,
                                width: Insets.i115,
                                decoration: BoxDecoration(
                                    color: appTheme.yellowIcon,
                                    borderRadius: SmoothBorderRadius(
                                        cornerRadius: AppRadius.r6,
                                        cornerSmoothing: AppRadius.r100)),
                                child: Text(language(context, "TopUp Wallet"),
                                    style: AppCss.lexendSemiBold14
                                        .textColor(appTheme.primary)))
                            .inkWell(onTap: () {
                          route.pushNamed(context, routeName.topUpWalletScreen);
                        })
                      ]).paddingSymmetric(horizontal: Insets.i20)
                ]).marginSymmetric(vertical: Insets.i25),
                Row(children: [
                  Expanded(
                      child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: Insets.i15),
                              height: Insets.i38,
                              decoration: BoxDecoration(
                                  color: myWalletPvr.showEarnings
                                      ? appTheme.primary
                                      : appTheme.bgBox,
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: AppRadius.r6,
                                      cornerSmoothing: AppRadius.r100)),
                              child: Text(language(context, "Total Earnings"),
                                  style: AppCss.lexendRegular14.textColor(
                                      myWalletPvr.showEarnings
                                          ? appTheme.white
                                          : appTheme.hintTextClr)))
                          .inkWell(onTap: () {
                    myWalletPvr.showEarnings = true;
                    // myWalletPvr.notifyListeners(); // Removed: Only call within provider
                  })),
                  HSpace(Insets.i15),
                  Expanded(
                      child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: Insets.i15),
                              height: Insets.i38,
                              decoration: BoxDecoration(
                                  color: myWalletPvr.showEarnings
                                      ? appTheme.bgBox
                                      : appTheme.primary,
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: AppRadius.r6,
                                      cornerSmoothing: AppRadius.r100)),
                              child: Text(language(context, "Withdraw History"),
                                  style: AppCss.lexendRegular14.textColor(
                                      myWalletPvr.showEarnings
                                          ? appTheme.hintTextClr
                                          : appTheme.white)))
                          .inkWell(onTap: () {
                    myWalletPvr.showEarnings = false;
                    // myWalletPvr.notifyListeners(); // Removed: Only call within provider
                  }))
                ]),
                Expanded(
                    child: ListView.builder(
                        itemCount: myWalletPvr.showEarnings
                            ? appArray.totalEarningTransactions.length
                            : appArray.withdrawHistory.length,
                        itemBuilder: (context, index) {
                          final transaction = myWalletPvr.showEarnings
                              ? appArray.totalEarningTransactions[index]
                              : appArray.withdrawHistory[index];
                          return CommonBgLayout(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                Row(children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: appTheme.bgBox,
                                          borderRadius: SmoothBorderRadius(
                                              cornerRadius: Insets.i6)),
                                      padding: EdgeInsets.all(Insets.i7),
                                      child:
                                          SvgPicture.asset(svgAssets.receipt)),
                                  HSpace(Insets.i10),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            language(
                                                context, transaction['type']),
                                            style: AppCss.lexendRegular12
                                                .textColor(
                                                    appTheme.hintTextClr)),
                                        VSpace(Insets.i5),
                                        Text(transaction['id'],
                                            style: AppCss.lexendRegular12
                                                .textColor(appTheme.primary))
                                      ])
                                ]),
                                Row(children: [
                                  SvgPicture.asset(transaction['isCredit']
                                      ? svgAssets.received
                                      : svgAssets.send1),
                                  Text(
                                      '\$${language(context, transaction['amount'].toString())}',
                                      style: AppCss.lexendMedium14.textColor(
                                          transaction['isCredit']
                                              ? appTheme.success
                                              : appTheme.alertZone))
                                ])
                              ])).marginSymmetric(vertical: 6);
                        })),
                CommonButton(
                    text: language(context, "Withdraw"),
                    onTap: () {
                      route.pushNamed(context, routeName.withdrawScreen);
                    }).marginOnly(bottom: Insets.i20)
              ]).marginSymmetric(horizontal: Insets.i20));
    });
  }
}
