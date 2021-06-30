import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/banner.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';

class BannerRepo {
  List<BannerData> bannerData = [];
 
  Future<List<BannerData>> getBannerList(BuildContext context) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/banner",
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjI1MDg1NTM1NzAsInJvbGUiOiJwdWJsaWMifQ.4-zFh5j6LyfpoB4uuVVWu1YaLIv-M9VWXrahBZ4JRGs"
          }
        )
      );
      BannerModel bannerModel = BannerModel.fromJson(json.decode(res.data));
      List<BannerData> _bannerData = bannerModel.body;
      bannerData = _bannerData; 
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
    return bannerData;
  }
}