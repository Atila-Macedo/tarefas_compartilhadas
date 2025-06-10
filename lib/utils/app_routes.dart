import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/task_list/task_list_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String taskList = '/task-list';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    home: (context) => const HomeScreen(),
    taskList: (context) => const TaskListScreen(),
    settings: (context) => const SettingsScreen(),
  };
}

