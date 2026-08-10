import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);

    const androidChannel = AndroidNotificationChannel(
      'reminders_channel',
      'Reminders',
      description: 'Notifications for product reminders',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }


  Future<void> scheduleReminder({
  required String title,
  required String body,
}) async {
  const androidDetails = AndroidNotificationDetails(
    'reminders_channel',
    'Reminders',
    channelDescription: 'Notifications for product reminders',
    importance: Importance.high,
    priority: Priority.high,
  );

  const iosDetails = DarwinNotificationDetails();

  const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

  await Future.delayed(const Duration(seconds: 10));

  await _plugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    details,
  );
}
}