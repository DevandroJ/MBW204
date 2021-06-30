
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/data/models/nearmember.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';

class NearMemberRepo {
  final SharedPreferences sharedPreferences;
  NearMemberRepo({
    @required this.sharedPreferences
  });

  Future<List<NearMemberData>> getNearMember(BuildContext context, double lat, double long) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/data/nearme?lat=$lat&lng=$long");
      NearMemberModel nearMemberModel = NearMemberModel.fromJson(json.decode(res.data));
      List<NearMemberData> listNearMemberData = nearMemberModel.body;
      return listNearMemberData;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      print(e);
    }
  }

}