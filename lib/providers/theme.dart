import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/utils/constant.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  ThemeProvider({@required this.sharedPreferences}) {
    loadCurrentTheme();
  }

  int pageIndex = 0;
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences.setBool(AppConstants.THEME, _darkTheme);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void loadCurrentTheme() async {
    _darkTheme = sharedPreferences.getBool(AppConstants.THEME) ?? false;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void updatePage(int i) {
    pageIndex = i;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

} 
