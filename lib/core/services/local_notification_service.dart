// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:injectable/injectable.dart';

// @lazySingleton
// class LocalNotificationService {
//   final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _plugin.initialize(initSettings);

//     const androidChannel = AndroidNotificationChannel(
//       'reminders_channel',
//       'Reminders',
//       description: 'Notifications for product reminders',
//       importance: Importance.high,
//     );

//     await _plugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(androidChannel);
//   }


//   Future<void> scheduleReminder({
//   required String title,
//   required String body,
// }) async {
//   const androidDetails = AndroidNotificationDetails(
//     'reminders_channel',
//     'Reminders',
//     channelDescription: 'Notifications for product reminders',
//     importance: Importance.high,
//     priority: Priority.high,
//   );

//   const iosDetails = DarwinNotificationDetails();

//   const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

//   await Future.delayed(const Duration(seconds: 10));

//   await _plugin.show(
//     DateTime.now().millisecondsSinceEpoch ~/ 1000,
//     title,
//     body,
//     details,
//   );
// }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  Function(String? payload)? onNotificationTap;

  Future<void> init() async {
    // 1. CRITICAL: Initialize timezone database so iOS receives valid time offsets
    tz.initializeTimeZones();
    try {
      // Set local location explicitly if needed, or let it detect device local
      final currentTimeZone = await DateTime.now().timeZoneName;
      // Alternatively, default to local if auto-detection fails
      tz.setLocalLocation(tz.local);
    } catch (e) {
      if (kDebugMode) print('Timezone init error: $e');
    }

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

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (onNotificationTap != null) {
          onNotificationTap!(payload);
        }
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'reminders_channel',
      'Reminders',
      description: 'Notifications for product reminders',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    try {
      final androidImplementation = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }

      final iosImplementation = _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      if (iosImplementation != null) {
        await iosImplementation.requestPermissions(alert: true, badge: true, sound: true);
      }
    } catch (e) {
      if (kDebugMode) print('Permission error: $e');
    }
  }

  Future<void> scheduleReminder({
    required String title,
    required String body,
    String? payload,
    int delaySeconds = 10,
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

    // Ensure timezone package has loaded local time correctly
    final tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: delaySeconds));

    if (kDebugMode) {
      print('Scheduling notification for: $scheduledTime (Current: ${tz.TZDateTime.now(tz.local)})');
    }

    try {
      await _plugin.zonedSchedule(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to schedule native notification: $e');
      }
    }
  }
}