import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/data/models/chat/list_chat.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/utils/dio.dart';
import 'package:mbw204_club_ina/data/models/chat/list_conversation.dart';

class ChatRepo {
  final SharedPreferences sharedPreferences;
  ChatRepo({@required this.sharedPreferences});

  List<ListConversationData> listConversationData = [];
  List<ListChatData> listChatData = [];

  Future<List<ListConversationData>> fetchListConversations(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("https://apidev.cxid.xyz:7443/api/v1/chat/conversation/c4b93a517a6bd43d9a5fd7289e719475");
      ListConversationModel listConversationModel = ListConversationModel.fromJson(res.data);
      List<ListConversationData> _listConversationData = listConversationModel.data;
      listConversationData = _listConversationData;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e.response.data);
      print(e?.response?.statusMessage);
    } catch(e) {
      print(e);
    }
    return listConversationData;
  } 

  Future<List<ListChatData>> fetchListChat(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_CHAT}/list");
      print(res.data);
      ListChatModel listChatModel = ListChatModel.fromJson(res.data);
      List<ListChatData> _listChatData = listChatModel.data;
      listChatData = _listChatData;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e.response.data);
      print(e?.response?.statusMessage);
    } catch(e) {
      print(e);
    }
    return listChatData;
  }

}
