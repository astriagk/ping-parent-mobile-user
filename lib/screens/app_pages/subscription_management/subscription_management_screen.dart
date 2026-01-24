import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/widgets/common_empty_state.dart';
import 'package:taxify_user_ui/widgets/common_error_state.dart';
import 'package:taxify_user_ui/widgets/skeletons/student_card_skeleton.dart';
import '../../../widgets/subscription_card/subscription_card.dart';
import '../../../provider/app_pages_providers/subscriptions_provider.dart';

class SubscriptionManagementScreen extends StatelessWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionsProvider>(
      builder: (context, subscriptionsCtrl, child) {
        return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => subscriptionsCtrl.onInit()),
          child: Scaffold(
            body: subscriptionsCtrl.isLoading
                ? const StudentListSkeleton()
                : subscriptionsCtrl.errorMessage != null
                    ? CommonErrorState(
                        title: appFonts.somethingWentWrong,
                        description: subscriptionsCtrl.errorMessage!,
                        buttonText: appFonts.refresh,
                        onButtonTap: () =>
                            subscriptionsCtrl.fetchSubscriptionPlans(),
                      )
                    : subscriptionsCtrl.subscriptionPlans.isEmpty
                        ? CommonEmptyState(
                            mainText: appFonts.noSubscriptionPlansAvailable,
                            descriptionText:
                                appFonts.noSubscriptionPlansDescription,
                            buttonText: appFonts.refresh,
                            onButtonTap: () =>
                                subscriptionsCtrl.fetchSubscriptionPlans(),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(
                              left: Sizes.s20,
                              right: Sizes.s20,
                              top: Sizes.s20,
                              bottom: Sizes.s100,
                            ),
                            itemCount:
                                subscriptionsCtrl.subscriptionPlans.length,
                            itemBuilder: (context, index) {
                              final plan =
                                  subscriptionsCtrl.subscriptionPlans[index];
                              return SubscriptionCard(
                                subscriptionData: plan.toMap(),
                                onTap: () {
                                  // Handle subscription plan selection
                                  print('Selected plan: ${plan.planId}');
                                },
                              ).paddingOnly(bottom: Sizes.s15);
                            },
                          ),
          ),
        );
      },
    );
  }
}
