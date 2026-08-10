import 'package:flutter/material.dart';
import 'package:office_task/features/auth/presentation/screen/login_screen.dart';
import 'package:office_task/features/auth/presentation/screen/splash_screen.dart';
import 'package:office_task/features/product/presentation/screen/home_screen.dart';



class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
  };
}