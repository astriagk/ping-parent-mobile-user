/// All API endpoint URLs
class Endpoints {
  // Use your computer's network IP for physical devices
  // For Android Emulator: use 10.0.2.2
  // For iOS Simulator: use localhost or 127.0.0.1
  // For Physical Device: use your computer's network IP (check with ipconfig/ifconfig)
  static const String baseUrl =
      'https://ping-parent-backend-m8yc.onrender.com/api';
  // static const String baseUrl = 'http://192.168.0.126:3000/api';
  static const String getUser = '$baseUrl/user';
  static const String login = '$baseUrl/login';

  // Verify Token Endpoint

  static const String verifyToken = '$baseUrl/auth/verify-token';

  // Auth Endpoints

  static const String sendOtp = '$baseUrl/auth/login/send-otp';
  static const String verifyOtp = '$baseUrl/auth/login/verify-otp';
  static const String registerSendOtp = '$baseUrl/auth/register/send-otp';
  static const String registerVerifyOtp = '$baseUrl/auth/register/verify-otp';

  // Profile Endpoints
  static const String parentProfile = '$baseUrl/parent/profile';

  // Student Endpoints
  static const String myStudents = '$baseUrl/students/my-students';
  static const String students = '$baseUrl/students';
  static String updateStudent(String id) => '$baseUrl/students/$id';

  // School Endpoints
  static const String schools = '$baseUrl/schools';

  // Parent Address Endpoints
  static const String parentAddress = '$baseUrl/parent/address';

  // Driver Endpoints
  static const String allDrivers =
      '$baseUrl/driver-student-assignments/all-drivers';
  static const String driverStudentAssignments =
      '$baseUrl/driver-student-assignments';

  // Subscription Endpoints
  static const String subscriptionPlans = '$baseUrl/subscription-plans';
  static const String subscriptionRecommendations =
      '$baseUrl/parent-subscriptions/recommendations';
  static const String parentSubscriptions = '$baseUrl/parent-subscriptions';
  static const String parentSubscriptionsUpgrade =
      '$baseUrl/parent-subscriptions/upgrade';
  static const String myActiveSubscription =
      '$baseUrl/parent-subscriptions/my-active-subscription';

  // Trip Tracking Endpoints
  static const String activeTrips = '$baseUrl/parent/trips/active';

  // QR/OTP Endpoints
  static String parentTripQrOtp(String tripId) =>
      '$baseUrl/daily-qr-otp/parent/trip/$tripId';

  // Payment Endpoints
  static const String payments = '$baseUrl/payments';

  // Razorpay Endpoints
  static const String razorpayConfig = '$baseUrl/razorpay/config';
  static const String razorpayOrders = '$baseUrl/razorpay/orders';
  static const String razorpayVerify = '$baseUrl/razorpay/verify';

  // Add more endpoints as needed
}
