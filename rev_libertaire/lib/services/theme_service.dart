import 'package:shared_preferences/shared_preferences.dart';

/// Service de gestion du thème (clair/sombre)
class ThemeService {
  static const String _themeKey = 'dark_mode';

  /// Récupère le mode sombre
  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  /// Active/désactive le mode sombre
  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  /// Bascule le mode sombre
  Future<bool> toggleDarkMode() async {
    final current = await isDarkMode();
    await setDarkMode(!current);
    return !current;
  }
}
