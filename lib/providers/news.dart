import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/news.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';

enum GetNewsStatus { loading, loaded, error, empty }

class NewsProvider with ChangeNotifier {

  GetNewsStatus _getNewsStatus = GetNewsStatus.loading;
  GetNewsStatus get getNewsStatus => _getNewsStatus;

  List<NewsBody> _newsBody = [];
  List<NewsBody> get newsBody => _newsBody;

  void setStateGetNewsStatus(GetNewsStatus getNewsStatus) {
    _getNewsStatus = getNewsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void getNews(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/article");
      NewsModel newsModel = NewsModel.fromJson(json.decode(res.data));
      _newsBody = [];
      List<NewsBody> listNewsBody = newsModel.body;
      _newsBody.addAll(listNewsBody);
      setStateGetNewsStatus(GetNewsStatus.loaded);
    } on ServerErrorException catch(_) {
      setStateGetNewsStatus(GetNewsStatus.error);
    } catch(e) {
      setStateGetNewsStatus(GetNewsStatus.error);
      print(e);
    }
  }

}