import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/banner.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';

class BannerRepo {
  List<BannerData> bannerData = [];
 
  Future<List<BannerData>> getBannerList(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/banner");
      BannerModel bannerModel = BannerModel.fromJson(json.decode(res.data));
      List<BannerData> _bannerData = bannerModel.body;
      bannerData = _bannerData; 
    } on DioError catch(_) {
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
    return bannerData;
  }
}