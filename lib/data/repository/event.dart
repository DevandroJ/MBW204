import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/event.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventRepo {
  final SharedPreferences sharedPreferences;
  EventRepo({
    this.sharedPreferences
  });
  List<EventData> eventData = [];
 
  Future<List<EventData>> getEvent(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/content-service/event");
      EventModel eventModel = EventModel.fromJson(json.decode(res.data));
      List<EventData> _eventData = eventModel.body;
      eventData = _eventData; 
      return eventData;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
    return eventData;
  }

  Future joinEvent(BuildContext context, int eventId) async {
    print(sharedPreferences.getString("userId"));
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL}/content-service/event-join", 
        data: {
          "user_id": sharedPreferences.getString("userId"),
          "event_id": eventId.toString()
        }
      );    
      print(res);
      } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
  } 
}