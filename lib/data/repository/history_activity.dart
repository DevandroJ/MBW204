
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/utils/dio.dart';
import 'package:mbw204_club_ina/data/models/history_activity.dart';

class HistoryActivityRepo {
  final SharedPreferences sharedPreferences;

  HistoryActivityRepo({
    this.sharedPreferences
  });

  Future<List<HistoryActivityData>> getHistoryActivity(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/history_activity/${sharedPreferences.getString("userId")}");
      HistoryActivityModel historyActivityModel = HistoryActivityModel.fromJson(json.decode(res.data));
      List<HistoryActivityData> historyActivityData = historyActivityModel.body;
      return historyActivityData;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      print(e);
    }
    return [];
  }
}