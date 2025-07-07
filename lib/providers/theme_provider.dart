import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _colorIndexKey = 'selectedColorIndex';
  static const String _darkModeKey = 'isDarkMode';

  int _selectedColorIndex = 0;
  bool _isDarkMode = false;

  // Lista de cores disponíveis para o tema
  static const List<Map<String, dynamic>> themeColors = [
    {
      'name': 'Azul',
      'color': Colors.blue,
      'primary': Colors.blue,
      'secondary': Colors.blueAccent,
    },
    {
      'name': 'Verde',
      'color': Colors.green,
      'primary': Colors.green,
      'secondary': Colors.greenAccent,
    },
    {
      'name': 'Roxo',
      'color': Colors.purple,
      'primary': Colors.purple,
      'secondary': Colors.purpleAccent,
    },
    {
      'name': 'Laranja',
      'color': Colors.orange,
      'primary': Colors.orange,
      'secondary': Colors.orangeAccent,
    },
    {
      'name': 'Rosa',
      'color': Colors.pink,
      'primary': Colors.pink,
      'secondary': Colors.pinkAccent,
    },
    {
      'name': 'Vermelho',
      'color': Colors.red,
      'primary': Colors.red,
      'secondary': Colors.redAccent,
    },
    {
      'name': 'Teal',
      'color': Colors.teal,
      'primary': Colors.teal,
      'secondary': Colors.tealAccent,
    },
    {
      'name': 'Indigo',
      'color': Colors.indigo,
      'primary': Colors.indigo,
      'secondary': Colors.indigoAccent,
    },
  ];

  int get selectedColorIndex => _selectedColorIndex;
  bool get isDarkMode => _isDarkMode;
  Color get selectedColor => themeColors[_selectedColorIndex]['color'];

  ThemeProvider() {
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedColorIndex = prefs.getInt(_colorIndexKey) ?? 0;
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    notifyListeners();
  }

  Future<void> _saveThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorIndexKey, _selectedColorIndex);
    await prefs.setBool(_darkModeKey, _isDarkMode);
  }

  void setColorIndex(int index) {
    if (index >= 0 && index < themeColors.length) {
      _selectedColorIndex = index;
      _saveThemeSettings();
      notifyListeners();
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveThemeSettings();
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    _saveThemeSettings();
    notifyListeners();
  }

  ThemeData getTheme() {
    final colorScheme = _isDarkMode ? Brightness.dark : Brightness.light;
    final primaryColor = themeColors[_selectedColorIndex]['color'];
    
    return ThemeData(
      brightness: colorScheme,
      primarySwatch: _getMaterialColor(primaryColor),
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: colorScheme,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  MaterialColor _getMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
} 