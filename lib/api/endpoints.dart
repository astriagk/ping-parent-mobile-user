/// All API endpoint URLs
class Endpoints {
  // Use your computer's network IP for physical devices
  // For Android Emulator: use 10.0.2.2
  // For iOS Simulator: use localhost or 127.0.0.1
  // For Physical Device: use your computer's network IP (check with ipconfig/ifconfig)
  static const String baseUrl =
      'https://ping-parent-backend-m8yc.onrender.com/api';
  // static const String baseUrl = 'http://192.168.0.126:3000/api';

  // static const String getUser = '$baseUrl/user';

  // Verify Token Endpoint
  static const String verifyToken = '$baseUrl/auth/verify-token';

// Auth Endpoints
  static const String sendOtp = '$baseUrl/auth/login/send-otp';
  static const String verifyOtp = '$baseUrl/auth/login/verify-otp';
  static const String registerSendOtp = '$baseUrl/auth/register/send-otp';
  static const String registerVerifyOtp = '$baseUrl/auth/register/verify-otp';

// Profile Endpoints
  static const String parentProfile = '$baseUrl/parent/profile';
  static const String sharedUpload = '$baseUrl/shared/upload';

// Student Endpoints
  static const String myStudents = '$baseUrl/parent/students';
  static const String students = '$baseUrl/parent/students';
  static String updateStudent(String id) => '$baseUrl/parent/students/$id';

// School Endpoints
  static const String schools = '$baseUrl/shared/schools';

// Parent Address Endpoints
  static const String parentAddress = '$baseUrl/parent/address';

// Assignment Endpoints
  static const String allDrivers = '$baseUrl/parent/assignments/all-drivers';
  static const String driverStudentAssignments = '$baseUrl/parent/assignments';

// Subscription Endpoints
  static const String subscriptionPlans = '$baseUrl/public/subscription-plans';
  static const String subscriptionRecommendations =
      '$baseUrl/parent/subscriptions/recommendations';
  static const String parentSubscriptions = '$baseUrl/parent/subscriptions';
  static const String parentSubscriptionsUpgrade =
      '$baseUrl/parent/subscriptions/upgrade';
  static const String myActiveSubscription =
      '$baseUrl/parent/subscriptions/active';

// Trip Tracking Endpoints
  static const String activeTrips = '$baseUrl/parent/trips/active';

// QR/OTP Endpoints
  static String parentTripQrOtp(String tripId) =>
      '$baseUrl/parent/qr-otp/trip/$tripId';

// Payment Endpoints
  static const String payments = '$baseUrl/parent/payments';

// Razorpay Endpoints
  static const String razorpayConfig = '$baseUrl/public/razorpay/config';
  static const String razorpayOrders = '$baseUrl/public/razorpay/orders';
  static const String razorpayVerify = '$baseUrl/public/razorpay/verify';

// Notification Endpoints
  static const String notifications = '$baseUrl/shared/notifications';
  static const String unreadNotifications =
      '$baseUrl/shared/notifications/unread';
  static const String unreadCount =
      '$baseUrl/shared/notifications/unread-count';
  static String markAsRead(String id) =>
      '$baseUrl/shared/notifications/$id/mark-as-read';
  static const String markAllAsRead =
      '$baseUrl/shared/notifications/mark-all-as-read';

// Device Token Endpoints
  static const String deviceTokenRegister =
      '$baseUrl/shared/device-tokens/register';
  static const String deviceTokenRemove =
      '$baseUrl/shared/device-tokens/remove';
}
