import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String isDark = 'isDark';

  static Future<void> setMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isDark, value);
  }

  static Future<bool> getMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isDark) ?? true;
  }
}
