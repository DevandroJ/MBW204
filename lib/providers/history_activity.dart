
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/history_activity.dart';
import 'package:mbw204_club_ina/data/repository/history_activity.dart';

enum GetHistoryActivityStatus { idle, loading, loaded, empty, error }

class HistoryActivityProvider with ChangeNotifier {
  final HistoryActivityRepo historyActivityRepo;

  HistoryActivityProvider({
    this.historyActivityRepo
  });

  GetHistoryActivityStatus _getHistoryActivityStatus = GetHistoryActivityStatus.loading;
  GetHistoryActivityStatus get getHistoryActivityStatus => _getHistoryActivityStatus;

  List<HistoryActivityData> _historyActivityData = [];
  List<HistoryActivityData> get historyActivityData => _historyActivityData;

  void setStateGetHistoryActivityStatus(GetHistoryActivityStatus getHistoryActivityStatus) {
    _getHistoryActivityStatus = getHistoryActivityStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
 
  Future getHistoryActivity(BuildContext context) async {
    try {
      List<HistoryActivityData> historyActivityData = await historyActivityRepo.getHistoryActivity(context);
      if(_historyActivityData.length != historyActivityData.length) {
        _historyActivityData.clear();
        _historyActivityData.addAll(historyActivityData);
        setStateGetHistoryActivityStatus(GetHistoryActivityStatus.loaded);
        if(_historyActivityData.length == 0) {
          setStateGetHistoryActivityStatus(GetHistoryActivityStatus.empty);
        }
      }
      setStateGetHistoryActivityStatus(GetHistoryActivityStatus.loaded);
    } catch(e) {
      setStateGetHistoryActivityStatus(GetHistoryActivityStatus.error);
      print(e);
    }
  } 

}