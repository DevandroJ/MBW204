import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/banner.dart';
import 'package:mbw204_club_ina/data/repository/banner.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';

enum BannerStatus { loading, loaded, empty, error }

class BannerProvider extends ChangeNotifier {
  final BannerRepo bannerRepo;
  BannerProvider({@required this.bannerRepo});

  BannerStatus _bannerStatus = BannerStatus.loading;
  BannerStatus get bannerStatus => _bannerStatus;

  List<Map<String, dynamic>> _bannerListMap = [];
  List<BannerData> _bannerList = [];
  List<BannerData> get bannerList => [..._bannerList];
  List<Map<String, dynamic>> get bannerListMap => [..._bannerListMap];
  
  int _currentIndex;
  int get currentIndex => _currentIndex;

  void setStateBannerStatus(BannerStatus bannerStatus) {
    _bannerStatus = bannerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void getBanner(BuildContext context) async {
    try {
      List<BannerData> bannerList = await bannerRepo.getBannerList(context);
      _bannerListMap.clear();
      for (int i = 0; i < bannerList.length; i++) {
        for (int z = 0; z < bannerList[i].media.length; z++) {
          _bannerListMap.add({
            "id": z,
            "path": bannerList[i].media[z].path
          });
          setStateBannerStatus(BannerStatus.loaded);
        }
      } 
      if(bannerListMap.isEmpty) {
        setStateBannerStatus(BannerStatus.empty);
      }
      _currentIndex = 0;
    } on ServerErrorException catch(_) {
      setStateBannerStatus(BannerStatus.error);
    } catch(e) {
      print(e);
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
