import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static late SharedPreferences _preferences;
  static Future<SharedPreferences> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<void> signout() => _preferences.clear();

  static const String _themeKey = 'ThemeKey';
  static const String _userTimeKey = 'UserTimeKey';
  static const String _chatTimeKey = 'ChatTimeKey';
  static const String _messageTimeKey = 'MessageTimeKey';
  static const String _agencyTimeKey = 'AgencyTimeKey';
  static const String _projectTimeKey = 'ProjectTimeKey';
  static const String _currentlySelectedAgencyKey =
      'CurrentlySelectedAgencyKey';
  static const String _boardTimeKey = 'BoardTimeKey';
  static const String _taskListTimeKey = 'TaskListTimeKey';
  static const String _taskCardTimeKey = 'TaskCardTimeKey';

  static Future<void> setThemeMode(int value) async =>
      await _preferences.setInt(_themeKey, value);
  //
  static Future<void> setLastUserFetch(int value) async =>
      await _preferences.setInt(_userTimeKey, value);
  static Future<void> setLastChatFetch(int value) async =>
      await _preferences.setInt(_chatTimeKey, value);
  static Future<void> setLastMessageFetch(int value) async =>
      await _preferences.setInt(_messageTimeKey, value);
  static Future<void> setAgencyFetch(int value) async =>
      await _preferences.setInt(_agencyTimeKey, value);
  static Future<void> setProjectFetch(int value) async =>
      await _preferences.setInt(_projectTimeKey, value);
  static Future<void> setBoardTimeKey(int value) async =>
      await _preferences.setInt(_boardTimeKey, value);
  static Future<void> setTaskListTimeKey(int value) async =>
      await _preferences.setInt(_taskListTimeKey, value);
  static Future<void> setTaskCardTimeKey(int value) async =>
      await _preferences.setInt(_taskCardTimeKey, value);
  static Future<void> setCurrentlySelectedAgency(String value) async =>
      await _preferences.setString(_currentlySelectedAgencyKey, value);

  static int? themeMode() => _preferences.getInt(_themeKey);
  static int? lastUserFetch() => _preferences.getInt(_userTimeKey);
  static int? lastChatFetch() => _preferences.getInt(_chatTimeKey);
  static int? lastMessageFetch() => _preferences.getInt(_messageTimeKey);
  static int? lastAgencyFetch() => _preferences.getInt(_agencyTimeKey);
  static int? lastProjectFetch() => _preferences.getInt(_projectTimeKey);
  static int? lastBoardFetch() => _preferences.getInt(_boardTimeKey);
  static int? lastTaskListFetch() => _preferences.getInt(_taskListTimeKey);
  static int? lastTaskCardFetch() => _preferences.getInt(_taskCardTimeKey);
  static String? currentlySelectedAgency() =>
      _preferences.getString(_currentlySelectedAgencyKey);
}
