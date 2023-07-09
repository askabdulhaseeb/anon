import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static late SharedPreferences _preferences;
  static Future<SharedPreferences> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<void> signout() => _preferences.clear();

  static const String _themeKey = 'ThemeKey';
  static const String _chatTimeKey = 'ChatTimeKey';
  static const String _agencyTimeKey = 'ChatTimeKey';
  static const String _currentlySelectedAgencyKey =
      'CurrentlySelectedAgencyKey';

  static Future<void> setThemeMode(int value) async =>
      await _preferences.setInt(_themeKey, value);
  //
  static Future<void> setLastChatFetch(int value) async =>
      await _preferences.setInt(_chatTimeKey, value);
  static Future<void> setAgencyFetch(int value) async =>
      await _preferences.setInt(_agencyTimeKey, value);
  //
  static Future<void> setCurrentlySelectedAgency(String value) async =>
      await _preferences.setString(_currentlySelectedAgencyKey, value);

  static int? themeMode() => _preferences.getInt(_themeKey);
  static int? lastChatFetch() => _preferences.getInt(_chatTimeKey);
  static int? lastAgencyFetch() => _preferences.getInt(_agencyTimeKey);
  static String? currentlySelectedAgency() =>
      _preferences.getString(_currentlySelectedAgencyKey);
}
