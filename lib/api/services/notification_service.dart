import 'dart:convert';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/notification_model.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService(this._apiClient);

  /// Get unique device ID using device_info_plus
  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return android.id;
    } else {
      final ios = await deviceInfo.iosInfo;
      return ios.identifierForVendor ?? '';
    }
  }

  /// Register FCM token with backend
  Future<bool> registerToken(String fcmToken) async {
    try {
      final deviceId = await _getDeviceId();
      final response = await _apiClient.post(
        Endpoints.deviceTokenRegister,
        body: {
          'fcm_token': fcmToken,
          'device_type': Platform.isAndroid ? 'android' : 'ios',
          'device_id': deviceId,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('FCM token registered successfully');
        return true;
      } else {
        debugPrint(
            'FCM token registration failed: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('FCM token registration error: $e');
      return false;
    }
  }

  /// Remove FCM token (call on logout)
  Future<void> removeToken(String fcmToken) async {
    await _apiClient.post(
      Endpoints.deviceTokenRemove,
      body: {
        'fcm_token': fcmToken,
      },
    );
  }

  /// Get all notifications
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get(Endpoints.notifications);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'] ?? [];
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get(Endpoints.unreadCount);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data']?['unread_count'] ?? 0;
    }
    return 0;
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _apiClient.put(Endpoints.markAsRead(notificationId));
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    await _apiClient.put(Endpoints.markAllAsRead);
  }
}
