import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/data/models/chat/response_send_message.dart';
import 'package:mbw204_club_ina/data/models/chat/list_chat.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';
import 'package:mbw204_club_ina/data/models/chat/list_conversation.dart';

class ChatRepo {
  final SharedPreferences sharedPreferences;
  ChatRepo({@required this.sharedPreferences});

  List<ListConversationData> listConversationData = [];
  List<ListChatData> listChatData = [];

  Future<List<ListConversationData>> fetchListConversations(BuildContext context, String groupId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_CHAT}/conversation/$groupId");
      print("${AppConstants.BASE_URL_CHAT}/conversation/$groupId");
      ListConversationModel listConversationModel = ListConversationModel.fromJson(res.data);
      List<ListConversationData> _listConversationData = listConversationModel.data;
      listConversationData = _listConversationData;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      print(e);
    }
    return listConversationData;
  } 

  Future<List<ListChatData>> fetchListChat(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_CHAT}/list");
      ListChatModel listChatModel = ListChatModel.fromJson(res.data);
      List<ListChatData> _listChatData = listChatModel.data;
      listChatData = _listChatData;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      print(e);
    }
    return listChatData;
  }

  Future<ResponseSendMessageConversationModelData> sendMessageToConversations(BuildContext context, String text, String identity) async {
    print(identity);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_CHAT}/write", 
        data: {
          "remote": identity,
          "type": "TEXT",
          "content": {
            "charset": "UTF_8",
            "text": text
          }
        }
      );
      ResponseSendMessageConversationModelData responseSendMessageConversationModelData = ResponseSendMessageConversationModelData.fromJson(res.data);
      return responseSendMessageConversationModelData;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      throw Error();
    } catch(e) {
      print(e);
    }
  }

  Future ackRead(BuildContext context, String chatId) async {
    try { 
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.put("${AppConstants.BASE_URL_CHAT}/ack/$chatId");
      print(res.data);
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      print(e);
    }
  }

  Future fetchUserPresence(BuildContext context, ) async {
    try { 
      Dio dio = await DioManager.shared.getClient(context);
      await dio.get("${AppConstants.BASE_URL_CHAT}/presence");
    } catch(e) {
      print(e);
    }
  }

}
