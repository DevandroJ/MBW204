import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/onboarding.dart';
import 'package:mbw204_club_ina/data/repository/onboarding.dart';

class OnBoardingProvider with ChangeNotifier {
  final OnBoardingRepo onboardingRepo;

  OnBoardingProvider({@required this.onboardingRepo});

  List<OnboardingModel> _onBoardingList = [];
  List<OnboardingModel> get onBoardingList => _onBoardingList;

  int _selectedIndex = 0;
  int get selectedIndex =>_selectedIndex;

  changeSelectIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }

  void initBoardingList() async {
    _onBoardingList.clear();
    _onBoardingList.addAll(onboardingRepo.getOnBoardingList());
    Future.delayed(Duration.zero, () => notifyListeners());
  }
}
