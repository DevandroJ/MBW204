import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/data/models/checkin_detail.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/data/models/checkin.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';

class CheckInRepo {
  final SharedPreferences sharedPreferences;
  CheckInRepo({@required this.sharedPreferences}); 

  CheckInModel checkInModel;
  CheckInDetailModel checkInDetailModel;

  Future<CheckInModel> getCheckIn(BuildContext context, [int limit = 10]) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/checkin?limit=$limit");
      CheckInModel _checkInModel = CheckInModel.fromJson(json.decode(res.data));
      checkInModel = _checkInModel;
    } on DioError catch(_) {
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
    return checkInModel;
  }

  Future<CheckInDetailModel> getCheckInDetailData(BuildContext context, int checkInId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/checkin-detail/$checkInId");

      CheckInDetailModel _checkInDetailModel = CheckInDetailModel.fromJson(json.decode(res.data));
      checkInDetailModel = _checkInDetailModel;
      return checkInDetailModel;
    } on DioError catch(_) {
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
    return checkInDetailModel;
  }

  Future joinCheckIn(BuildContext context, int checkInId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL}/content-service/checkin-detail", data: {
        "checkin_id": checkInId,
        "user_id": sharedPreferences.getString("userId")
      });
    } on DioError catch(e) {
      if(json.decode(e.response.data)['code'] == 400) {
        throw ServerErrorException('User already joined');
      }
    } catch(e) {
      print(e);
    }
  }

  Future createCheckIn(
    BuildContext context,
    String caption, 
    String date, 
    String start, 
    String end, 
    String placeName,
    double lat, double long
  ) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL}/content-service/checkin", data: {
        "user_id": sharedPreferences.getString("userId"),
        "caption": caption,
        "place_name": placeName,
        "date": date,
        "start": start,
        "end": end,
        "lat": lat.toString(),
        "long": long.toString()
      });
      return res;
    } on DioError catch(e) {
      print(e?.response?.data);
      print(e?.response?.statusCode);
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
  }

}