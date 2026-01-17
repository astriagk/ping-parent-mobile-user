import 'package:taxify_user_ui/config.dart';
import '../../../widgets/ride_card/ride_card.dart';
import '../../../widgets/ride_card/layout/ride_data_model.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/subscription_provider.dart';

class SubscriptionManagementScreen extends StatelessWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
        builder: (context, subscriptionCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => subscriptionCtrl.onInit()),
          child: Scaffold(
              body: Column(children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  HSpace(Sizes.s20),
                  ...subscriptionCtrl.subscriptionStatus.asMap().entries.map(
                      (e) => TextWidgetCommon(
                              text: e.value,
                              color: subscriptionCtrl.selectStatus == e.key
                                  ? appColor(context).appTheme.white
                                  : appColor(context).appTheme.darkText)
                          .padding(vertical: Sizes.s11, horizontal: Sizes.s12)
                          .decorated(
                              color: subscriptionCtrl.selectStatus == e.key
                                  ? appColor(context).appTheme.primary
                                  : appColor(context).appTheme.white,
                              allRadius: Sizes.s6,
                              sideColor: subscriptionCtrl.selectStatus == e.key
                                  ? appColor(context).appTheme.primary
                                  : appColor(context).appTheme.bgBox,
                              boxShadow: [
                                BoxShadow(
                                    color: appColor(context)
                                        .appTheme
                                        .primary
                                        .withValues(alpha: 0.04),
                                    blurRadius: 12,
                                    spreadRadius: 4)
                              ])
                          .inkWell(
                              onTap: () =>
                                  subscriptionCtrl.selectedOptionIndex(e.key))
                          .padding(vertical: Sizes.s20, right: Sizes.s12)),
                ])),
            Expanded(
                child: subscriptionCtrl.filteredSubscriptionList.isEmpty
                    ? Center(
                        child: TextWidgetCommon(
                          text:
                              language(context, appFonts.noSubscriptionsFound),
                          style: AppCss.lexendRegular14
                              .textColor(appColor(context).appTheme.lightText),
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.only(bottom: Sizes.s80),
                        children: [
                            ...subscriptionCtrl.filteredSubscriptionList
                                .asMap()
                                .entries
                                .map((entries) {
                              var e = entries.value;
                              var index = entries.key;
                              return RideCard(
                                rideData: RideDataModel.fromMap(e),
                                index: index,
                                onTap: () {
                                  // Navigate to subscription details screen
                                  route.pushNamed(context,
                                      routeName.subscriptionManagementScreen,
                                      arg: {
                                        'index': index,
                                        'value': entries.value
                                      });
                                },
                              );
                            })
                          ]))
          ])));
    });
  }
}
