import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final Brightness brightness =
          SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return _themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppThemes {
  static const Color _primary = Colors.deepPurple;
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
      surfaceTintColor: _darkScaffoldColor,
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
    dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 0.5),
    dividerColor: Colors.grey.shade300,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      tileColor: _darkScaffoldColor,
      horizontalTitleGap: 10,
    ),
    dialogTheme: const DialogTheme(surfaceTintColor: _darkScaffoldColor),
    bottomSheetTheme:
        const BottomSheetThemeData(surfaceTintColor: _darkScaffoldColor),
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
      surfaceTintColor: _lightScaffoldColor,
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
    dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 0.5),
    dividerColor: Colors.grey.shade300,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity(vertical: -4),
      tileColor: _lightScaffoldColor,
      horizontalTitleGap: 10,
    ),
    dialogTheme: const DialogTheme(surfaceTintColor: _lightScaffoldColor),
    bottomSheetTheme:
        const BottomSheetThemeData(surfaceTintColor: _lightScaffoldColor),
    colorScheme: const ColorScheme.light(
      primary: _primary,
      secondary: _secondary,
    ),
  );
}
