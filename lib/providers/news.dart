import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/news.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';

enum GetNewsStatus { loading, loaded, error, empty }

class NewsProvider with ChangeNotifier {

  GetNewsStatus _getNewsStatus = GetNewsStatus.loading;
  GetNewsStatus get getNewsStatus => _getNewsStatus;

  List<NewsBody> _newsBody = [];
  List<NewsBody> get newsBody => [..._newsBody];

  void setStateGetNewsStatus(GetNewsStatus getNewsStatus) {
    _getNewsStatus = getNewsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void getNews(BuildContext context) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/article",
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjE2MjU0NzgyNjMsInBob25lIjoiNjI4OTY3MDU1ODM4MSIsInJvbGUiOiJ1c2VyIiwic2NvcGUiOlsidXNlci52aWV3IiwidXNlci5yZWFkIiwidXNlci5jcmVhdGUiLCJ1c2VyLnVwZGF0ZSIsInVzZXIuZGVsZXRlIiwibWVkaWEudmlldyIsIm1lZGlhLnJlYWQiLCJtZWRpYS5jcmVhdGUiLCJtZWRpYS5kZWxldGUiLCJ0cmFuc2FjdGlvbi52aWV3IiwidHJhbnNhY3Rpb24ucmVhZCIsInRyYW5zYWN0aW9uLmNyZWF0ZSIsInRyYW5zYWN0aW9uLnVwZGF0ZSIsInRyYW5zYWN0aW9uLmRlbGV0ZSIsIm1lZGlhLnVwZGF0ZSIsInVzZXIubGlzdCIsInVzZXIuYWxsIiwibWVkaWEubGlzdCIsInRyYW5zYWN0aW9uLmxpc3QiLCJzb3MubGlzdCIsInNvcy52aWV3Iiwic29zLnJlYWQiLCJzb3MuY3JlYXRlIiwic29zLnVwZGF0ZSIsInNvcy5kZWxldGUiLCJjb21tb24udXNlciIsImRhdGEubGlzdCIsImRhdGEudmlldyIsImRhdGEucmVhZCIsImRhdGEuY3JlYXRlIiwiZGF0YS5kZWxldGUiLCJkYXRhLnVwZGF0ZSIsImNsdWIubGlzdCIsImNsdWIudmlldyIsImNsdWIucmVhZCIsImNsdWIudXBkYXRlIiwiY2x1Yi5kZWxldGUiLCJ0b2tlbi51cGRhdGUiLCJwb3N0Lmxpc3QiLCJwb3N0LnZpZXciLCJwb3N0LmNyZWF0ZSIsInBvc3QucmVhZCIsInBvc3QudXBkYXRlIiwicG9zdC5kZWxldGUiLCJjb21tZW50Lmxpc3QiLCJjb21tZW50LnZpZXciLCJjb21tZW50LmNyZWF0ZSIsImNvbW1lbnQucmVhZCIsImNvbW1lbnQudXBkYXRlIiwiY29tbWVudC5kZWxldGUiLCJjbHViLmNyZWF0ZSIsImFkbWluLnVzZXIiLCJkZXBvc2l0Lmxpc3QiLCJkZXBvc2l0LnZpZXciLCJkZXBvc2l0LnJlYWQiLCJkZXBvc2l0LmNyZWF0ZSIsImRlcG9zaXQudXBkYXRlIiwiZGVwb3NpdC5kZWxldGUiLCJjYXRlZ29yeS52aWV3IiwiY2F0ZWdvcnkuYWRkIiwid2FsbGV0LmNyZWF0ZSIsImNhdGVnb3J5Lmxpc3QiLCJjYXRlZ29yeS5jcmVhdGUiLCJjYXRlZ29yeS51cGRhdGUiLCJwcm9kdWN0Lmxpc3QiLCJwcm9kdWN0LnJlYWQiLCJwcm9kdWN0LmNyZWF0ZSIsInByb2R1Y3QudXBkYXRlIiwicHJvZHVjdC5kZWxldGUiLCJwcm9kdWN0LnZpZXciLCJ3YWxsZXQubGlzdCIsIndhbGxldC52aWV3Iiwid2FsbGV0LnJlYWQiXSwic3ViIjoiNjI4OTY3MDU1ODM4MSIsInVpZCI6ImVjNjRkZGIyLTA4MDItNDJhOC05NjI3LTQ3NmRkMmJkMWUxOSJ9.cuQWOe59rrOHihhP5j0eXLvHGlMl-fk5QDYu3gJHsvM"
          }
        )
      );
      NewsModel newsModel = NewsModel.fromJson(json.decode(res.data));
      _newsBody = [];
      List<NewsBody> listNewsBody = newsModel.body;
      _newsBody.addAll(listNewsBody);
      setStateGetNewsStatus(GetNewsStatus.loaded);
      if(_newsBody.isEmpty) {
        setStateGetNewsStatus(GetNewsStatus.empty);
      }
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } on ServerErrorException catch(_) {
      setStateGetNewsStatus(GetNewsStatus.error);
    } catch(e) {
      setStateGetNewsStatus(GetNewsStatus.error);
      print(e);
    }
  }

}