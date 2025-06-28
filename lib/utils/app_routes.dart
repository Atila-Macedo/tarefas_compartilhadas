import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/task_list/task_list_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/theme_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String taskList = '/task-list';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String theme = '/theme';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    home: (context) => const HomeScreen(),
    settings: (context) => const SettingsScreen(),
    profile: (context) => const ProfileScreen(),
    theme: (context) => const ThemeScreen(),
  };

  // Rota dinâmica para TaskListScreen (não pode ser const devido ao parâmetro)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == taskList) {
      final args = settings.arguments as Map<String, dynamic>?;
      final taskListId = args?['taskListId'] as String? ?? '';
      return MaterialPageRoute(
        builder: (context) => TaskListScreen(taskListId: taskListId),
      );
    }
    return null;
  }
}

