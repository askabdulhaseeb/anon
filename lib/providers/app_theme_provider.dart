import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../database/local/local_data.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode =
      LocalData.themeMode() == null || LocalData.themeMode() == 0
          ? ThemeMode.system
          : LocalData.themeMode() == 1
              ? ThemeMode.light
              : ThemeMode.dark;

  // ThemeMode get themeMode => _themeMode;
  ThemeMode get themeMode => ThemeMode.light;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final Brightness brightness =
          SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return _themeMode == ThemeMode.dark;
    }
  }

  Future<void> switchMode(ThemeMode value) async {
    _themeMode = value;
    await LocalData.setThemeMode(value.index);
    notifyListeners();
  }

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppThemes {
  static const Color _primary = Color(0xFF673AB7);
  static const Color _secondary = Color.fromRGBO(2, 122, 190, 1);

  static const Color _darkScaffoldColor = Color(0xFF101018);
  static const Color _lightScaffoldColor = Colors.white;

  //
  // Dark
  //
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: _lightScaffoldColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    scaffoldBackgroundColor: _darkScaffoldColor,
    primaryColor: _primary,
    iconTheme: const IconThemeData(color: Colors.white),
    dividerTheme:
        DividerThemeData(color: Colors.grey.shade200, thickness: 1, space: 0),
    dividerColor: Colors.grey.shade300,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity(vertical: -4),
      horizontalTitleGap: 10,
    ),
    dialogTheme: const DialogTheme(surfaceTintColor: _darkScaffoldColor),
    bottomSheetTheme: const BottomSheetThemeData(),
    colorScheme: const ColorScheme.dark(
      primary: _primary,
      secondary: _secondary,
    ),
  );

  //
  // Light
  //
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: _darkScaffoldColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: _primary,
    iconTheme: const IconThemeData(color: Colors.black),
    dividerTheme:
        DividerThemeData(color: Colors.grey.shade200, thickness: 1, space: 0),
    dividerColor: Colors.grey.shade300,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity(vertical: -4),
      horizontalTitleGap: 10,
    ),
    dialogTheme: const DialogTheme(surfaceTintColor: _lightScaffoldColor),
    bottomSheetTheme: const BottomSheetThemeData(),
    colorScheme: const ColorScheme.light(
      primary: _primary,
      secondary: _secondary,
    ),
  );
}
