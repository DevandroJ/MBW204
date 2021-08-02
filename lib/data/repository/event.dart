import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/data/models/event.dart';
import 'package:mbw204_club_ina/data/models/event_search.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';

class EventRepo {
  final SharedPreferences sharedPreferences;
  EventRepo({
    this.sharedPreferences
  });
  List<EventBody> eventBody = [];
  List<EventSearchData> eventSearchData = [];
 
  Future<List<EventBody>> getEvent(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/event");
      EventModel eventModel = EventModel.fromJson(json.decode(res.data));
      List<EventBody> _eventBody = eventModel.data;
      eventBody = _eventBody; 
      return eventBody;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
    return eventBody;
  }

  Future<List<EventSearchData>> getEventSearchData(BuildContext context, String query) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/event/search?event=$query");
      EventSearchModel eventSearchModel = EventSearchModel.fromJson(json.decode(res.data)); 
      List<EventSearchData> _eventSearchData = eventSearchModel.body;
      eventSearchData = _eventSearchData;
      return eventSearchData;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      print(e);
    }
    return eventSearchData;
  }

  Future joinEvent(BuildContext context, int eventId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL}/content-service/event-join", 
        data: {
          "user_id": sharedPreferences.getString("userId"),
          "event_id": eventId.toString()
        }
      );    
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
  } 

}