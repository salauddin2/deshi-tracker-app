import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../repositories/notification_repository.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif = FlutterLocalNotificationsPlugin();
  final NotificationRepository _repository;

  NotificationService(this._repository);

  Future<void> init() async {
    try {
      // 1. Request Permission
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('FCM: User granted permission');
        
        // 2. Get token and register
        String? token = await _fcm.getToken();
        if (token != null) {
          debugPrint('FCM Token: $token');
          await _repository.registerDeviceToken(token, _getPlatform());
        }

        // 3. Listen for token refreshes
        _fcm.onTokenRefresh.listen((newToken) {
          _repository.registerDeviceToken(newToken, _getPlatform());
        });

        // 4. Foreground listener
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      }
    } catch (e) {
      debugPrint('NotificationService init failed (Firebase not configured?): $e');
    }
  }

  String _getPlatform() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return 'android';
      case TargetPlatform.iOS: return 'ios';
      default: return 'desktop';
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('FCM Message: ${message.notification?.title}');
    
    // Show local notification
    _localNotif.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
