import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../firebase_options.dart';

/// Must be a top-level function (not inside a class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background message handler runs in a separate isolate.
  // Initialize Firebase for this isolate before using messaging APIs.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Background message received — the system notification is shown automatically.
  // FCM plugin handles showing the notification.
}

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Call this ONCE after successful login
  Future<void> initialize({
    required Future<void> Function(String) onRegisterToken,
    required Function(RemoteMessage) onNotificationTapped,
  }) async {
    // 1. Request permission (required for iOS, Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }

    // 2. Setup local notifications (for foreground display)
    await _setupLocalNotifications();

    // 3. Get FCM token and register with backend
    final fcmToken = await _messaging.getToken();
    if (fcmToken != null) {
      await onRegisterToken(fcmToken);
    }

    // 4. Listen for token refresh (tokens can change)
    _messaging.onTokenRefresh.listen((newToken) {
      onRegisterToken(newToken);
    });

    // 5. Handle foreground messages (app is open)
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 6. Handle notification tap when app was in background
    FirebaseMessaging.onMessageOpenedApp.listen(onNotificationTapped);

    // 7. Handle notification tap that launched the app (was terminated)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        onNotificationTapped(initialMessage);
      });
    }
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Create the notification channel (Android)
    const channel = AndroidNotificationChannel(
      'ping_parent_notifications',
      'Ping Parent Notifications',
      description: 'Trip and student notifications',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    // Show local notification since FCM doesn't auto-show in foreground
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ping_parent_notifications',
          'Ping Parent Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: message.data['notification_type'],
    );
  }

  /// Get current FCM token (for logout flow)
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
