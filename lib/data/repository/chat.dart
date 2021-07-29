import 'dart:io';

// import 'package:dio/dio.dart'; 
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/data/models/chat/list_conversation.dart';

class ChatRepo {
  final SharedPreferences sharedPreferences;
  ChatRepo({@required this.sharedPreferences});

  List<ListConversationData> listConversationData = [];

  Future<List<ListConversationData>> fetchListConversations(BuildContext context) async {
    try {
      // Dio dio = await DioManager.shared.getClient(context);
      // Response res = await dio.get("https://apidev.cxid.xyz:7443/api/v1/chat/conversation/c4b93a517a6bd43d9a5fd7289e719475");
      // ListConversationModel listConversationModel = ListConversationModel.fromJson(res.data);
      // List<ListConversationData> _listConversationData = listConversationModel.data;
      // listConversationData = _listConversationData;
      HttpClient ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      IOClient http = IOClient(ioc);
      String url = "https://apidev.cxid.xyz:7443/api/v1/chat/conversation/c4b93a517a6bd43d9a5fd7289e719475";
      Response response = await http.get(url,
        headers: {
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          "X-Context-ID": "761512637635"
        }
      );
      print("Bearer ${sharedPreferences.getString("token")}");
      print(response.body);
    // } on DioError catch(e) {
    //   print(e?.response?.statusCode);
    //   print(e.response.data);
    //   print(e?.response?.statusMessage);
    } catch(e) {
      print(e);
    }
    return listConversationData;
  } 
}
