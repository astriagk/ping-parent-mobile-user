import 'package:skolo/config.dart';
import 'package:skolo/widgets/common_empty_state.dart';
import 'package:skolo/widgets/common_error_state.dart';
import 'package:skolo/widgets/skeletons/student_card_skeleton.dart';
import 'package:skolo/provider/app_pages_providers/subscriptions_provider.dart';
import 'package:skolo/widgets/loading/payment_loading_overlay.dart';
import 'package:skolo/widgets/student_selection_bottom_sheet.dart';
import 'layouts/school_coverage_card.dart';
import 'layouts/subscription_plans_list.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> with WidgetsBindingObserver {
  bool _isActivatingSubscription = false;
  String? _pendingPlanId;
  bool _pendingIsUpgrade = false;
  List<String>? _pendingStudentIds;
  late final RazorpayProvider _razorpayProvider;
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    _razorpayProvider = context.read<RazorpayProvider>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _razorpayProvider.addListener(_onPaymentStateChanged);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _razorpayProvider.removeListener(_onPaymentStateChanged);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    } else if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      context
          .read<SubscriptionsProvider>()
          .fetchRecommendations(isRefresh: true);
    }
  }

  void _onPaymentStateChanged() {
    final razorpayCtrl = context.read<RazorpayProvider>();
    if (razorpayCtrl.isPaymentSuccess &&
        _pendingPlanId != null &&
        !_isActivatingSubscription) {
      _activateSubscription(_pendingPlanId!, _pendingIsUpgrade);
    }
  }

  Future<void> _activateSubscription(String planId, bool isUpgrade) async {
    if (_isActivatingSubscription) return;
    setState(() => _isActivatingSubscription = true);

    final subscriptionsCtrl = context.read<SubscriptionsProvider>();
    bool success;
    if (isUpgrade) {
      success = await subscriptionsCtrl.upgradeSubscription(planId);
    } else {
      success = await subscriptionsCtrl.createSubscription(
        planId,
        studentIds: _pendingStudentIds,
      );
    }

    if (mounted) {
      final razorpayCtrl = context.read<RazorpayProvider>();
      razorpayCtrl.reset();
      setState(() {
        _isActivatingSubscription = false;
        _pendingPlanId = null;
        _pendingStudentIds = null;
      });

      if (!success && subscriptionsCtrl.errorMessage != null) {
        _showErrorDialog(subscriptionsCtrl.errorMessage!);
        subscriptionsCtrl.clearError();
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: TextWidgetCommon(
          text: appFonts.somethingWentWrong,
          style: AppCss.lexendSemiBold16
              .textColor(appColor(context).appTheme.darkText),
        ),
        content: TextWidgetCommon(
          text: message,
          style: AppCss.lexendRegular14
              .textColor(appColor(context).appTheme.lightText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: TextWidgetCommon(
              text: appFonts.done,
              style: AppCss.lexendSemiBold14
                  .textColor(appColor(context).appTheme.activeColor),
            ),
          ),
        ],
      ),
    );
  }

  /// Always shows a student-selection sheet for new subscriptions,
  /// then initiates payment with the chosen student IDs.
  Future<void> _handleSubscribeTap({
    required SubscriptionsProvider subscriptionsCtrl,
    required RazorpayProvider razorpayCtrl,
    required String planId,
    required bool isUpgrade,
    required int amount,
    required String description,
    required int kidsCovered,
  }) async {
    List<String>? studentIds;

    if (!isUpgrade) {
      final summary = subscriptionsCtrl.parentSummary;
      if (summary != null && summary.kids.isNotEmpty) {
        final selected = await showStudentSelectionBottomSheet(
          context: context,
          allStudents: summary.kids,
          coveredStudents: summary.coveredStudents,
          uncoveredStudents: summary.uncoveredStudents,
          maxStudents: kidsCovered > 0 ? kidsCovered : null,
        );
        if (selected == null) return; // user dismissed
        studentIds = selected;
      }
    }

    _pendingPlanId = planId;
    _pendingIsUpgrade = isUpgrade;
    _pendingStudentIds = studentIds;
    razorpayCtrl.initiatePayment(
      amount: amount,
      subscriptionId: planId,
      description: description,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SubscriptionsProvider, RazorpayProvider>(
      builder: (context, subscriptionsCtrl, razorpayCtrl, child) {
        final hasNoData = subscriptionsCtrl.recommendedPlans.isEmpty &&
            subscriptionsCtrl.currentSubscriptions.isEmpty;

        return Scaffold(
          body: Stack(
            children: [
              subscriptionsCtrl.isLoading
                  ? const StudentListSkeleton()
                  : subscriptionsCtrl.errorMessage != null
                      ? CommonErrorState(
                          title: appFonts.somethingWentWrong,
                          description: subscriptionsCtrl.errorMessage!,
                          buttonText: appFonts.refresh,
                          onButtonTap: () =>
                              subscriptionsCtrl.fetchRecommendations(),
                        )
                      : subscriptionsCtrl.coveredBySchool
                          ? SchoolCoverageCard(
                              currentSubscriptions:
                                  subscriptionsCtrl.currentSubscriptions,
                            )
                          : hasNoData
                              ? CommonEmptyState(
                                  mainText:
                                      appFonts.noSubscriptionPlansAvailable,
                                  descriptionText:
                                      appFonts.noSubscriptionPlansDescription,
                                  buttonText: appFonts.refresh,
                                  onButtonTap: () =>
                                      subscriptionsCtrl.fetchRecommendations(),
                                )
                              : SubscriptionPlansList(
                                  subscriptionsCtrl: subscriptionsCtrl,
                                  razorpayCtrl: razorpayCtrl,
                                  isActivatingSubscription:
                                      _isActivatingSubscription,
                                  onSubscribeTap: (
                                    planId,
                                    isUpgrade,
                                    amount,
                                    description,
                                    kidsCovered,
                                  ) =>
                                      _handleSubscribeTap(
                                    subscriptionsCtrl: subscriptionsCtrl,
                                    razorpayCtrl: razorpayCtrl,
                                    planId: planId,
                                    isUpgrade: isUpgrade,
                                    amount: amount,
                                    description: description,
                                    kidsCovered: kidsCovered,
                                  ),
                                ),
              if (razorpayCtrl.isLoading || _isActivatingSubscription)
                PaymentLoadingOverlay(),
            ],
          ),
        );
      },
    );
  }
}
