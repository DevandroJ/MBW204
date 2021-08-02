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

  Future getNews(BuildContext context) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/article",
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjI1MDg1NTM1NzAsInJvbGUiOiJwdWJsaWMifQ.4-zFh5j6LyfpoB4uuVVWu1YaLIv-M9VWXrahBZ4JRGs"
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