import 'package:flutter/foundation.dart';

import '../enums/bottom_nav.dart';

class AppNavProvider extends ChangeNotifier {
  int _currentIndex =
      kDebugMode ? BottomNav.project.count : BottomNav.project.count;
  bool _isMute = true;
  void onTabInt(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void onTabEnum(BottomNav value) {
    _currentIndex = value.count;
    notifyListeners();
  }

  int get currentTap => _currentIndex;
  bool get isMute => _isMute;

  void toggleMuteButton() {
    _isMute = !_isMute;
    notifyListeners();
  }
}
