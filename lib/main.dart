import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:office_task/core/services/local_notification_service.dart';
import 'package:office_task/core/services/push_notification_service.dart';
import 'package:office_task/firebase_options.dart';

import 'core/di/injection.dart';
import 'core/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  await getIt<LocalNotificationService>().init();
  await getIt<PushNotificationService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}