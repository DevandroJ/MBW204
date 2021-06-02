import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:mbw204_club_ina/data/models/checkin.dart';
import 'package:mbw204_club_ina/data/models/checkin_detail.dart';
import 'package:mbw204_club_ina/data/repository/checkin.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CheckInStatus { loading, loaded, empty, error }
enum CheckInStatusCreate { idle, loading, loaded, error }
enum CheckInStatusJoin { idle, loading, loaded, error }
enum CheckInStatusDetail { idle, loading, loaded, error, empty }

class CheckInProvider extends ChangeNotifier {
  final CheckInRepo checkInRepo;
  CheckInProvider({this.checkInRepo});

  CheckInStatus _checkInStatus = CheckInStatus.loading;
  CheckInStatus get checkInStatus => _checkInStatus;

  CheckInStatusCreate _checkInStatusCreate = CheckInStatusCreate.idle;
  CheckInStatusCreate get checkInStatusCreate => _checkInStatusCreate;

  CheckInStatusJoin _checkInStatusJoin = CheckInStatusJoin.idle;
  CheckInStatusJoin get checkInStatusJoin => _checkInStatusJoin;

  CheckInStatusDetail _checkInStatusDetail = CheckInStatusDetail.idle;
  CheckInStatusDetail get checkInStatusDetail => _checkInStatusDetail;

  CheckInModel checkInModel;
  List<Map<String, dynamic>> checkInDataAssign = [];
  List<CheckInData> _checkInData = [];
  List<CheckInData> get checkInData => _checkInData;

  int checkInTotalUser = 0;
  List<CheckInDetailData> _checkInDetailData = [];
  List<CheckInDetailData> get checkInDetailData => _checkInDetailData;
  
  void setStateCheckInStatus(CheckInStatus checkInStatus) {
    _checkInStatus = checkInStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCheckInStatusCreate(CheckInStatusCreate checkInStatusCreate) {
    _checkInStatusCreate = checkInStatusCreate;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCheckInStatusJoin(CheckInStatusJoin checkInStatusJoin) {
    _checkInStatusJoin = checkInStatusJoin;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCheckInStatusDetail(CheckInStatusDetail checkInStatusDetail) {
    _checkInStatusDetail = checkInStatusDetail;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void getCheckIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setStateCheckInStatus(CheckInStatus.loading);
      _checkInData = [];
      checkInDataAssign = [];
      CheckInModel _checkInModel = await checkInRepo.getCheckIn(context);
      checkInModel = _checkInModel;
      _checkInData.addAll(_checkInModel.body);
      for (int i = 0; i < _checkInData.length; i++) {
        CheckInDetailModel checkInDetailModel = await checkInRepo.getCheckInDetailData(context, checkInModel.body[i].checkinId);
        if(i < checkInDetailModel.body.length) {
          checkInDataAssign.add({
            "checkin_id": _checkInData[i].checkinId,
            "user_id": _checkInData[i].userId,
            "fullname": _checkInData[i].fullname,
            "caption": _checkInData[i].caption,
            "place_name": _checkInData[i].placeName,
            "date": _checkInData[i].date,
            "start": _checkInData[i].start,
            "end": _checkInData[i].end,
            "lat": _checkInData[i].lat,
            "long": _checkInData[i].long,
            "joined": checkInDetailModel.body[i].userId == prefs.getString("userId"),
            "total": checkInDetailModel.totalUser
          });
        } else {  
          checkInDataAssign.add({
            "checkin_id": _checkInData[i].checkinId,
            "user_id": _checkInData[i].userId,
            "fullname": _checkInData[i].fullname,
            "caption": _checkInData[i].caption,
            "place_name": _checkInData[i].placeName,
            "date": _checkInData[i].date,
            "start": _checkInData[i].start,
            "end": _checkInData[i].end,
            "lat": _checkInData[i].lat,
            "long": _checkInData[i].long,
            "total": checkInDetailModel.totalUser,
            "joined": checkInDetailModel.body.any((el) => el.userId == prefs.getString("userId"))
          });
        }
      }
      setStateCheckInStatus(CheckInStatus.loaded);
      if(_checkInData.length == 0) {
        setStateCheckInStatus(CheckInStatus.empty);
      }  
    } on ServerErrorException catch(_) {
      setStateCheckInStatus(CheckInStatus.error);
    } catch(e) {
      setStateCheckInStatus(CheckInStatus.error);
      print(e);
    }
  }

  Future getCheckInDetail(BuildContext context, int checkInId) async {
    try {
      setStateCheckInStatusDetail(CheckInStatusDetail.loading);
      _checkInDetailData = [];
      CheckInDetailModel checkInDetailModel = await checkInRepo.getCheckInDetailData(context, checkInId);
      checkInTotalUser = checkInDetailModel.totalUser;
      _checkInDetailData.addAll(checkInDetailModel.body);
      setStateCheckInStatusDetail(CheckInStatusDetail.loaded);
      if(_checkInDetailData.length == 0) {
        setStateCheckInStatusDetail(CheckInStatusDetail.empty);
      }
    } on ServerErrorException catch(_) {
      setStateCheckInStatusDetail(CheckInStatusDetail.error);
    } catch(e) {
      setStateCheckInStatusDetail(CheckInStatusDetail.error);
      print(e);
    }
  }

  Future createCheckIn(BuildContext context, String caption, String date, String start, String end, String placeName, double lat, double long) async {
    try {
      setStateCheckInStatusCreate(CheckInStatusCreate.loading);
      await checkInRepo.createCheckIn(context, caption, date, start, end, placeName, lat, long);
      showAnimatedDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ClassicGeneralDialogWidget(
            titleText: 'CheckIn Created',
            contentText: '',
            positiveTextStyle: TextStyle(
              color: ColorResources.GREEN
            ),
            positiveText: 'OK',
            onPositiveClick: () {
              Navigator.of(context).pop();
            },
          );
        },
        animationType: DialogTransitionType.scale,
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 1),
      ).then((_) => {
        Navigator.of(context).pop()
      });
      getCheckIn(context);
      setStateCheckInStatusCreate(CheckInStatusCreate.loaded);
    } on ServerErrorException catch(_) {
      setStateCheckInStatusCreate(CheckInStatusCreate.error);
    } catch(e) {
      setStateCheckInStatusCreate(CheckInStatusCreate.error);
      print(e);
    }
  }

  Future joinCheckIn(BuildContext context, int checkInId) async {
    try {
      setStateCheckInStatusJoin(CheckInStatusJoin.loading);
      await checkInRepo.joinCheckIn(context, checkInId);
      showAnimatedDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ClassicGeneralDialogWidget(
            titleText: 'Has been Joined',
            contentText: '',
            positiveTextStyle: TextStyle(
              color: ColorResources.GREEN
            ),
            positiveText: 'OK',
            onPositiveClick: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          );
        },
        animationType: DialogTransitionType.scale,
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 1),
      );
      getCheckIn(context);
      setStateCheckInStatusJoin(CheckInStatusJoin.loaded);
    } on ServerErrorException catch(_) {
      showAnimatedDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ClassicGeneralDialogWidget(
            titleText: 'Already joined',
            contentText: '',
            positiveTextStyle: TextStyle(
              color: ColorResources.GREEN
            ),
            positiveText: 'OK',
            onPositiveClick: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          );
        },
        animationType: DialogTransitionType.scale,
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 1),
      );
      setStateCheckInStatusJoin(CheckInStatusJoin.error);
    } catch(e) {
      setStateCheckInStatusJoin(CheckInStatusJoin.error);
      print(e);
    }
  }

}
