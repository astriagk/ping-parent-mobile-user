/// Feature flags to control which architecture version is used for each feature.
///
/// During migration, use these flags to toggle between old code (lib/) and
/// new code (lib_new/) for each feature independently.
///
/// Pattern:
///   false = Use old code from lib/
///   true  = Use new code from lib_new/
///
/// Example workflow:
///   1. Set useNewAuth = false → build app → test (old auth works)
///   2. Set useNewAuth = true → build app → test (new auth works)
///   3. If new auth works → keep flag ON, move to next feature
///   4. If issues → keep flag OFF, fix, try again
library;

class FeatureFlags {
  /// Authentication feature (sign in, OTP, logout)
  /// Old: lib/screens/auth_screen/ + lib/provider/auth_providers/
  /// New: lib_new/features/auth/
  static const bool useNewAuth = false;

  /// User profile feature (view, edit profile)
  /// Old: lib/screens/app_pages/profile_screen/ + lib/provider/app_pages_providers/user_provider.dart
  /// New: lib_new/features/profile/
  static const bool useNewProfile = false;

  /// Students management (add, edit, delete students)
  /// Old: lib/screens/app_pages/student_screen/ + lib/provider/app_pages_providers/add_student_provider.dart
  /// New: lib_new/features/students/
  static const bool useNewStudents = false;

  /// Subscriptions feature (plans, active subscription, recommendations, redeem code)
  /// Old: lib/screens/app_pages/subscription_management/ + lib/provider/app_pages_providers/subscriptions_provider.dart
  /// New: lib_new/features/subscriptions/
  static const bool useNewSubscriptions = false;

  /// Trips feature (active trips, trip tracking, real-time position)
  /// Old: lib/screens/app_pages/accept_ride_screen/ + lib/provider/bottom_provider/trip_tracking_provider.dart
  /// New: lib_new/features/trips/
  static const bool useNewTrips = false;

  /// Payments feature (Razorpay integration, wallet, payment history)
  /// Old: lib/screens/app_pages/my_wallet_screen/ + lib/provider/app_pages_providers/razorpay_provider.dart
  /// New: lib_new/features/payments/
  static const bool useNewPayments = false;

  /// Notifications feature (notification list, mark as read)
  /// Old: lib/screens/app_pages/notification/ + lib/provider/app_pages_providers/notification_provider.dart
  /// New: lib_new/features/notifications/
  static const bool useNewNotifications = false;

  /// Approvals feature (cross-app approval status, pull-to-refresh)
  /// Old: No old code (new feature only)
  /// New: lib_new/features/approvals/
  /// Note: This is a NEW feature with no old implementation
  static const bool useNewApprovals = false;

  /// Toggle ALL features at once (useful for testing)
  /// When true: overrides all individual flags and uses new code for everything
  static const bool useAllNew = false;

  /// Helper method to check if a feature should use new architecture
  static bool isFeatureNewArch(String featureName) {
    if (useAllNew) return true;

    switch (featureName.toLowerCase()) {
      case 'auth':
        return useNewAuth;
      case 'profile':
        return useNewProfile;
      case 'students':
        return useNewStudents;
      case 'subscriptions':
        return useNewSubscriptions;
      case 'trips':
        return useNewTrips;
      case 'payments':
        return useNewPayments;
      case 'notifications':
        return useNewNotifications;
      case 'approvals':
        return useNewApprovals;
      default:
        return false;
    }
  }

  /// Debug method: log current flag status
  static void printStatus() {
    // ignore: avoid_print
    print('=== Feature Flags Status ===');
    // ignore: avoid_print
    print('useNewAuth: $useNewAuth');
    // ignore: avoid_print
    print('useNewProfile: $useNewProfile');
    // ignore: avoid_print
    print('useNewStudents: $useNewStudents');
    // ignore: avoid_print
    print('useNewSubscriptions: $useNewSubscriptions');
    // ignore: avoid_print
    print('useNewTrips: $useNewTrips');
    // ignore: avoid_print
    print('useNewPayments: $useNewPayments');
    // ignore: avoid_print
    print('useNewNotifications: $useNewNotifications');
    // ignore: avoid_print
    print('useNewApprovals: $useNewApprovals');
    // ignore: avoid_print
    print('useAllNew: $useAllNew');
    // ignore: avoid_print
    print('===========================');
  }
}
