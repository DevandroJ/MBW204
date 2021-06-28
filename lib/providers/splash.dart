import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/config.dart';
import 'package:mbw204_club_ina/data/repository/splash.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;
  SplashProvider({@required this.splashRepo});

  ConfigModel _configModel;
  List<String> _languageList;
  int _languageIndex = 0;

  ConfigModel get configModel => _configModel;
  List<String> get languageList => _languageList;
  int get languageIndex => _languageIndex;

  Future<bool> initConfig() {
    _configModel = splashRepo.getConfig();
    _languageList = splashRepo.getLanguageList();
    Future.delayed(Duration.zero, () => notifyListeners());
    return Future.value(true);
  }
 
}
