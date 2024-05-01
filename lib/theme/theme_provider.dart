import 'package:flutter/material.dart';
import 'package:habittracker/theme/dark_mode.dart';
import 'package:habittracker/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = LightMode;

  //get theme data
  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == DarkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    if (_themeData == LightMode) {
      _themeData = DarkMode;
    } else {
      _themeData = LightMode;
    }
    notifyListeners();
  }

}
