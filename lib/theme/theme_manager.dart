import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
///Author: 
///Date: 5/14/24
///Description: allows theme to change depending on user action
///Bugs: None Known
class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeManager() {
    // Load theme setting at startup
    loadThemeMode();
  }

  get themeMode => _themeMode;

  // Changes the theme
  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await saveThemeMode(isDark);
    notifyListeners();
  }

  // Loads the theme from local storage
  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isDark')) {
      bool isDark = prefs.getBool('isDark')!;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  // Saves the theme to local storage
  Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }
}
