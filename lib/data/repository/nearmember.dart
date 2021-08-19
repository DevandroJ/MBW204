
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/data/models/nearmember.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';

class NearMemberRepo {
  final SharedPreferences sharedPreferences;
  NearMemberRepo({
    @required this.sharedPreferences
  });

  List<NearMemberData> listNearMemberData = [];

  Future<List<NearMemberData>> getNearMember(BuildContext context, double lat, double long) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/data/nearme?lat=$lat&lng=$long");
      if(json.decode(res.data)["body"] == null) {
        throw NullException();
      }
      NearMemberModel nearMemberModel = NearMemberModel.fromJson(json.decode(res.data));
      List<NearMemberData> nearMemberData = nearMemberModel.body;
      listNearMemberData = nearMemberData;
      return listNearMemberData;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } on NullException catch(_) {
      throw NullException();
    }
    return listNearMemberData;
  }

}