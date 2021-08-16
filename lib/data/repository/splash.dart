import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/data/models/config.dart';

class SplashRepo {
  final SharedPreferences sharedPreferences;
  SplashRepo({@required this.sharedPreferences});

  ConfigModel getConfig() {
    ConfigModel configModel = ConfigModel();
    return configModel;
  }

  List<String> getLanguageList() {
    List<String> languageList = ['English', 'Indonesia'];
    return languageList;
  }
}
