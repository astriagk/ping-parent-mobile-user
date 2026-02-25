import 'package:taxify_user_ui/widgets/skeletons/my_wallet_skeleton.dart';

import 'package:provider/provider.dart';

import '../../../config.dart';
import '../../../provider/app_pages_providers/my_wallet_provider.dart';
import '../../../widgets/common_app_bar_layout1.dart';
import '../../../widgets/common_bg_layout.dart';
import '../../../widgets/common_empty_state.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modal = ModalRoute.of(context);
    if (modal != null) {
      routeObserver.subscribe(this, modal);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // Screen was pushed onto navigator — fetch fresh data
    final p = Provider.of<MyWalletProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      p.setShowEarnings(true);
      p.fetchPayments();
    });
  }

  @override
  void didPopNext() {
    // Returned to this screen (another screen was popped) — refresh data
    final p = Provider.of<MyWalletProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      p.setShowEarnings(true);
      p.fetchPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MyWalletProvider, DashBoardProvider>(
        builder: (context, myWalletPvr, bottomCtrl, child) {
      return Scaffold(
          appBar: CommonAppBarLayout1(
              title: language(context, appFonts.payments),
              titleWidth: MediaQuery.of(context).size.width * 0.01),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Stack(alignment: Alignment.centerLeft, children: [
                //   Image.asset('assets/image/setting/my_wallet.png',
                //       width: double.infinity),
                //   Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(language(context, appFonts.totalBalance),
                //                   style: AppCss.lexendRegular12
                //                       .textColor(appTheme.onBoardTxtClr)),
                //               VSpace(Insets.i4),
                //               Text("\$${language(context, "2300.99")}",
                //                   style: AppCss.lexendBold16
                //                       .textColor(appTheme.white))
                //             ]),
                //         Container(
                //                 alignment: Alignment.center,
                //                 height: Insets.i36,
                //                 width: Insets.i115,
                //                 decoration: BoxDecoration(
                //                     color: appTheme.yellowIcon,
                //                     borderRadius: SmoothBorderRadius(
                //                         cornerRadius: AppRadius.r6,
                //                         cornerSmoothing: AppRadius.r100)),
                //                 child: Text(language(context, appFonts.topUpWallet),
                //                     style: AppCss.lexendSemiBold14
                //                         .textColor(appTheme.primary)))
                //             .inkWell(onTap: () {
                //           route.pushNamed(context, routeName.topUpWalletScreen);
                //         })
                //       ]).paddingSymmetric(horizontal: Insets.i20)
                // ]).marginSymmetric(vertical: Insets.i25),

                VSpace(Insets.i15),
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
                              child: Text(language(context, appFonts.completed),
                                  style: AppCss.lexendRegular14.textColor(
                                      myWalletPvr.showEarnings
                                          ? appTheme.white
                                          : appTheme.hintTextClr)))
                          .inkWell(onTap: () {
                    myWalletPvr.setShowEarnings(true);
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
                              child: Text(language(context, appFonts.pending),
                                  style: AppCss.lexendRegular14.textColor(
                                      myWalletPvr.showEarnings
                                          ? appTheme.hintTextClr
                                          : appTheme.white)))
                          .inkWell(onTap: () {
                    myWalletPvr.setShowEarnings(false);
                  }))
                ]),

                Expanded(
                  child: myWalletPvr.isLoading
                      ? const MyWalletSkeleton()
                      : (myWalletPvr.payments.isEmpty
                          ? CommonEmptyState(
                              mainText: myWalletPvr.errorMessage != null
                                  ? language(context, myWalletPvr.errorMessage)
                                  : language(context, appFonts.noPayments),
                              descriptionText: myWalletPvr.errorMessage ??
                                  language(
                                      context, appFonts.noPaymentsDescription),
                              buttonText: myWalletPvr.errorMessage != null
                                  ? language(context, appFonts.retry)
                                  : language(context, appFonts.mySubscriptions),
                              onButtonTap: () {
                                if (myWalletPvr.errorMessage != null) {
                                  myWalletPvr.fetchPayments();
                                } else {
                                  Navigator.of(context).pop();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    bottomCtrl.tabChange(2);
                                  });
                                }
                              },
                              showBackButton: false,
                            )
                          : ListView.builder(
                              itemCount: myWalletPvr.showEarnings
                                  ? myWalletPvr.completedPayments.length
                                  : myWalletPvr.pendingPayments.length,
                              itemBuilder: (context, index) {
                                final raw = myWalletPvr.showEarnings
                                    ? myWalletPvr.completedPayments[index]
                                    : myWalletPvr.pendingPayments[index];

                                // Map API fields to the UI fields expected elsewhere
                                final transaction = {
                                  'type': raw['payment_type'] ?? '',
                                  'id': raw['transaction_id'] ?? '',
                                  'amount': raw['amount'] ?? 0,
                                  'isCredit':
                                      (raw['payment_status'] == 'completed')
                                };

                                return CommonBgLayout(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      Row(children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                color: appTheme.bgBox,
                                                borderRadius:
                                                    SmoothBorderRadius(
                                                        cornerRadius:
                                                            Insets.i6)),
                                            padding: EdgeInsets.all(Insets.i7),
                                            child: SvgPicture.asset(
                                                svgAssets.receipt)),
                                        HSpace(Insets.i10),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  language(context,
                                                      transaction['type']),
                                                  style: AppCss.lexendRegular12
                                                      .textColor(appTheme
                                                          .hintTextClr)),
                                              VSpace(Insets.i5),
                                              Text(transaction['id'],
                                                  style: AppCss.lexendRegular12
                                                      .textColor(
                                                          appTheme.primary))
                                            ])
                                      ]),
                                      Row(children: [
                                        SvgPicture.asset(transaction['isCredit']
                                            ? svgAssets.received
                                            : svgAssets.send1),
                                        Text(
                                            language(
                                                context,
                                                transaction['amount']
                                                    .toString()),
                                            style: AppCss.lexendMedium14
                                                .textColor(
                                                    transaction['isCredit']
                                                        ? appTheme.success
                                                        : appTheme.alertZone))
                                      ])
                                    ])).marginSymmetric(vertical: 6);
                              })),
                  // CommonButton(
                  //     text: language(context, "Withdraw"),
                  //     onTap: () {
                  //       route.pushNamed(context, routeName.withdrawScreen);
                  //     }).marginOnly(bottom: Insets.i20)
                )
              ]).marginSymmetric(horizontal: Insets.i20));
    });
  }
}
