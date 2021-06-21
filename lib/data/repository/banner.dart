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
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjE2MjQ4NjAxMjksInBob25lIjoiNjI4OTY3MDU1ODM4MSIsInJvbGUiOiJ1c2VyIiwic2NvcGUiOlsidXNlci52aWV3IiwidXNlci5yZWFkIiwidXNlci5jcmVhdGUiLCJ1c2VyLnVwZGF0ZSIsInVzZXIuZGVsZXRlIiwibWVkaWEudmlldyIsIm1lZGlhLnJlYWQiLCJtZWRpYS5jcmVhdGUiLCJtZWRpYS5kZWxldGUiLCJ0cmFuc2FjdGlvbi52aWV3IiwidHJhbnNhY3Rpb24ucmVhZCIsInRyYW5zYWN0aW9uLmNyZWF0ZSIsInRyYW5zYWN0aW9uLnVwZGF0ZSIsInRyYW5zYWN0aW9uLmRlbGV0ZSIsIm1lZGlhLnVwZGF0ZSIsInVzZXIubGlzdCIsInVzZXIuYWxsIiwibWVkaWEubGlzdCIsInRyYW5zYWN0aW9uLmxpc3QiLCJzb3MubGlzdCIsInNvcy52aWV3Iiwic29zLnJlYWQiLCJzb3MuY3JlYXRlIiwic29zLnVwZGF0ZSIsInNvcy5kZWxldGUiLCJjb21tb24udXNlciIsImRhdGEubGlzdCIsImRhdGEudmlldyIsImRhdGEucmVhZCIsImRhdGEuY3JlYXRlIiwiZGF0YS5kZWxldGUiLCJkYXRhLnVwZGF0ZSIsImNsdWIubGlzdCIsImNsdWIudmlldyIsImNsdWIucmVhZCIsImNsdWIudXBkYXRlIiwiY2x1Yi5kZWxldGUiLCJ0b2tlbi51cGRhdGUiLCJwb3N0Lmxpc3QiLCJwb3N0LnZpZXciLCJwb3N0LmNyZWF0ZSIsInBvc3QucmVhZCIsInBvc3QudXBkYXRlIiwicG9zdC5kZWxldGUiLCJjb21tZW50Lmxpc3QiLCJjb21tZW50LnZpZXciLCJjb21tZW50LmNyZWF0ZSIsImNvbW1lbnQucmVhZCIsImNvbW1lbnQudXBkYXRlIiwiY29tbWVudC5kZWxldGUiLCJjbHViLmNyZWF0ZSIsImFkbWluLnVzZXIiLCJkZXBvc2l0Lmxpc3QiLCJkZXBvc2l0LnZpZXciLCJkZXBvc2l0LnJlYWQiLCJkZXBvc2l0LmNyZWF0ZSIsImRlcG9zaXQudXBkYXRlIiwiZGVwb3NpdC5kZWxldGUiLCJjYXRlZ29yeS52aWV3IiwiY2F0ZWdvcnkuYWRkIiwid2FsbGV0LmNyZWF0ZSIsImNhdGVnb3J5Lmxpc3QiLCJjYXRlZ29yeS5jcmVhdGUiLCJjYXRlZ29yeS51cGRhdGUiLCJwcm9kdWN0Lmxpc3QiLCJwcm9kdWN0LnJlYWQiLCJwcm9kdWN0LmNyZWF0ZSIsInByb2R1Y3QudXBkYXRlIiwicHJvZHVjdC5kZWxldGUiLCJwcm9kdWN0LnZpZXciLCJ3YWxsZXQubGlzdCIsIndhbGxldC52aWV3Iiwid2FsbGV0LnJlYWQiXSwic3ViIjoiNjI4OTY3MDU1ODM4MSIsInVpZCI6ImVjNjRkZGIyLTA4MDItNDJhOC05NjI3LTQ3NmRkMmJkMWUxOSJ9.IfH0sYip4U42hHeeVx7KCk7YrKEjPFe_u3djNxFGncA"
          }
        )
      );
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