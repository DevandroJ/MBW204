import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/nearmember.dart';
import 'package:mbw204_club_ina/data/repository/nearmember.dart';

enum NearMemberStatus { loading, loaded, empty, error }

class NearMemberProvider with ChangeNotifier {
  final NearMemberRepo nearMemberRepo;
  NearMemberProvider({ @required this.nearMemberRepo });

  List<NearMemberData> _nearMemberData = [];
  List<NearMemberData> get nearMemberData => _nearMemberData;

  NearMemberStatus _nearMemberStatus = NearMemberStatus.loading;
  NearMemberStatus get nearMemberStatus => _nearMemberStatus;

  void setStateNearMemberStatus(NearMemberStatus nearMemberStatus) {
    _nearMemberStatus = nearMemberStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void getNearMember(BuildContext context, double lat, double long) async {
    setStateNearMemberStatus(NearMemberStatus.loading);
    try {
      List<NearMemberData> nearMemberData = await nearMemberRepo.getNearMember(context, lat, long);
      if(nearMemberData != null) {
        _nearMemberData.addAll(nearMemberData);
        setStateNearMemberStatus(NearMemberStatus.loaded);
        if(_nearMemberData.isEmpty) {
          setStateNearMemberStatus(NearMemberStatus.empty);
        }
      } else {
        setStateNearMemberStatus(NearMemberStatus.empty);
      }
    } catch(e) {
      print(e);
    }
  }

}