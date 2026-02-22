import 'package:taxify_user_ui/screens/app_pages/completed_ride_screen/completed_ride_screen.dart';
import 'package:taxify_user_ui/screens/app_pages/subscription_management/subscription_management_screen.dart';

import '../config.dart';
import '../screens/app_pages/my_wallet_screen/layouts/top_up_wallet_screen.dart';
import '../screens/app_pages/my_wallet_screen/layouts/withdraw_screen.dart';
import '../screens/app_pages/my_wallet_screen/my_wallet_screen.dart';
import '../screens/app_pages/no_internet_screen/no_internet_screen.dart';
import '../screens/app_pages/review_driver_screen/review_driver_screen.dart';
import '../screens/app_pages/student_screen/add_student_screen.dart';
import '../screens/app_pages/student_screen/student_list_screen.dart';
import '../screens/app_pages/driver_screen/assign_driver_screen.dart';

class AppRoute {
  Map<String, Widget Function(BuildContext)> route = {
    routeName.splash: (p0) => const AuthCheckWidget(
          authenticatedScreen: DashBoard(),
          unauthenticatedScreen: SplashScreen(),
        ),
    routeName.signInScreen: (p0) => const SignInScreen(),
    routeName.signUpScreen: (p0) => const SignUpScreen(),
    routeName.otpScreen: (p0) => const OtpScreen(),
    routeName.dashBoardLayout: (p0) => const DashBoard(),
    routeName.emptyNotification: (p0) => const EmptyNotification(),
    routeName.notificationScreen: (p0) => const NotificationScreen(),
    routeName.addNewLocationScreen: (p0) => const AddNewLocationScreen(),
    routeName.addLocationScreen: (p0) => const AddLocationScreen(),
    routeName.profileScreen: (p0) => const ProfileScreen(),
    routeName.bankDetailsScreen: (p0) => const BankDetailsScreen(),
    routeName.promoScreen: (p0) => const PromoScreen(),
    routeName.saveLocationScreen: (p0) => const SaveLocationScreen(),
    routeName.appSettingScreen: (p0) => const AppSettingScreen(),
    routeName.chatScreen: (p0) => const ChatScreen(),
    routeName.dateTimePicker: (p0) => const DateTimePicker(),
    routeName.searchLocationScreen: (p0) => const SearchLocationScreen(),
    routeName.chooseRiderScreen: (p0) => const ChooseRiderScreen(),
    routeName.addNewRiderScreen: (p0) => const AddNewRiderScreen(),
    routeName.selectRiderScreen: (p0) => const SelectRiderScreen(),
    routeName.acceptRideScreen: (p0) => const AcceptRideScreen(),
    routeName.outStationScreen: (p0) => const OutStationScreen(),
    routeName.findingDriverScreen: (p0) => const FindingDriverScreen(),
    routeName.rentalScreen: (p0) => const RentalScreen(),
    routeName.rentalInfoScreen: (p0) => const RentalInfoScreen(),
    routeName.driverDetailScreen: (p0) => const DriverDetailScreen(),
    routeName.completedRideScreen: (p0) => const CompletedRideScreen(),
    routeName.topUpWalletScreen: (p0) => const TopUpWalletScreen(),
    routeName.withdrawScreen: (p0) => const WithdrawScreen(),
    routeName.myWalletScreen: (p0) => const MyWalletScreen(),
    routeName.noInternetScreen: (p0) => const NoInternetScreen(),
    routeName.reviewDriverScreen: (p0) => const ReviewDriverScreen(),
    routeName.studentListScreen: (p0) => const StudentListScreen(),
    routeName.addStudentScreen: (p0) => const AddStudentScreen(),
    routeName.assignDriverScreen: (p0) => const AssignDriverScreen(),
    routeName.subscriptionManagementScreen: (p0) =>
        const SubscriptionManagementScreen(),
  };
}
