import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:skolo/config.dart';
import 'package:skolo/api/api_client.dart';
import 'package:skolo/api/models/notification_model.dart';
import 'package:skolo/api/services/notification_service.dart';
import 'package:skolo/api/services/push_notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService =
      NotificationService(ApiClient());
  final PushNotificationService _pushService = PushNotificationService();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;

  /// Initialize push notifications — call after successful login
  Future<void> initPushNotifications(BuildContext context) async {
    try {
      await _pushService.initialize(
        onRegisterToken: (fcmToken) async {
          await _notificationService.registerToken(fcmToken);
        },
        onNotificationTapped: (RemoteMessage message) {
          _handleNotificationTap(context, message);
        },
      );
    } catch (e) {
      debugPrint('Failed to initialize push notifications: $e');
    }
  }

  /// Handle notification tap navigation
  void _handleNotificationTap(BuildContext context, RemoteMessage message) {
    final type = message.data['notification_type'];
    final tripId = message.data['tripId'];

    switch (type) {
      case 'picked_up':
      case 'dropped':
      case 'approaching':
        if (tripId != null) {
          route.pushNamed(context, routeName.notificationScreen);
        }
        break;
      case 'payment_due':
        route.pushNamed(context, routeName.myWalletScreen);
        break;
      default:
        route.pushNamed(context, routeName.notificationScreen);
    }
  }

  /// Fetch all notifications from backend
  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();
    try {
      _notifications = await _notificationService.getNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch unread count
  Future<void> fetchUnreadCount() async {
    try {
      _unreadCount = await _notificationService.getUnreadCount();
      notifyListeners();
    } catch (e) {
      // silently fail
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = NotificationModel(
          id: _notifications[index].id,
          title: _notifications[index].title,
          message: _notifications[index].message,
          notificationType: _notifications[index].notificationType,
          isRead: true,
          createdAt: _notifications[index].createdAt,
          data: _notifications[index].data,
        );
        _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
        notifyListeners();
      }
    } catch (e) {
      // silently fail
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      _notifications = _notifications
          .map((n) => NotificationModel(
                id: n.id,
                title: n.title,
                message: n.message,
                notificationType: n.notificationType,
                isRead: true,
                createdAt: n.createdAt,
                data: n.data,
              ))
          .toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      // silently fail
    }
  }

  /// Remove FCM token — call on logout
  Future<void> removePushToken() async {
    try {
      final fcmToken = await _pushService.getToken();
      if (fcmToken != null) {
        await _notificationService.removeToken(fcmToken);
      }
    } catch (e) {
      debugPrint('Failed to remove push token: $e');
    }
  }
}
