import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import 'local_notification_service.dart';

@lazySingleton
class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotificationService;

  PushNotificationService(this._localNotificationService);

 Future<void> init() async {
  await _messaging.requestPermission();

  try {
    final token = await _messaging.getToken();
    print('FCM Token: $token');
  } catch (e) {
    print('Could not get FCM token (expected on iOS Simulator): $e');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _localNotificationService.scheduleReminder(
        title: notification.title ?? 'New notification',
        body: notification.body ?? '',
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Notification tapped: ${message.data}');
  });
}
}