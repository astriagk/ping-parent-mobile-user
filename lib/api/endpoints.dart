/// All API endpoint URLs
class Endpoints {
  // Use your computer's network IP for physical devices
  // For Android Emulator: use 10.0.2.2
  // For iOS Simulator: use localhost or 127.0.0.1
  // For Physical Device: use your computer's network IP (check with ipconfig/ifconfig)
  static const String baseUrl = 'http://192.168.0.126:3000/api';
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

  // Add more endpoints as needed
}
