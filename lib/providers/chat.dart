import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/chat/list_chat.dart';
import 'package:mbw204_club_ina/data/models/chat_message.dart';
import 'package:mbw204_club_ina/data/models/chat/list_conversation.dart';
import 'package:mbw204_club_ina/data/repository/chat.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

enum GetChatStatus { idle, loading, loaded, error, isEmpty }
enum GetListConversations { idle, loading, loaded, error, isEmpty }
enum SendMessageStatus { idle, loading, loaded, error, isEmpty }

class ChatProvider with ChangeNotifier {
  final ChatRepo chatRepo;
  ChatProvider({
    this.chatRepo
  });

  GetListConversations _getListConversations = GetListConversations.loading;
  GetListConversations get getListConversations =>  _getListConversations;

  GetChatStatus _getChatStatus = GetChatStatus.loading;
  GetChatStatus get getChatStatus => _getChatStatus;

  SendMessageStatus _sendMessageStatus = SendMessageStatus.loading;
  SendMessageStatus get sendMessageStatus => _sendMessageStatus;

  List<ListConversationData> _listConversationData = [];
  List<ListConversationData> get listConversationsData => [..._listConversationData];

  List<ListChatData> _listChatData = [];
  List<ListChatData> get listChatData => [..._listChatData];

  void setStateGetListConversations(GetListConversations getListConversations) {
    _getListConversations = getListConversations;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateGetChatStatus(GetChatStatus getChatStatus) {
    _getChatStatus = getChatStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSendMessage(SendMessageStatus sendMessageMessageStatus) {
    _sendMessageStatus = sendMessageMessageStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  } 
  
  Future fetchListChat(BuildContext context) async {
    try {
      List<ListChatData> listChatData = await chatRepo.fetchListChat(context);
      if(listChatData != null || listChatData.isNotEmpty) {
        if(listChatData.length != _listChatData.length) {
          _listChatData.clear();
          _listChatData.addAll(listChatData);
          setStateGetChatStatus(GetChatStatus.loaded);
        }
      } else {
        setStateGetChatStatus(GetChatStatus.isEmpty);
      }
    } catch(e) {
      setStateGetChatStatus(GetChatStatus.error);
      print(e);
    }
  }

  Future fetchListConversations(BuildContext context, String groupId) async {
    try {
      List<ListConversationData> listConversationDatas = await chatRepo.fetchListConversations(context, groupId);
      _listConversationData.clear();
      _listConversationData.addAll(listConversationDatas);
      setStateGetListConversations(GetListConversations.loaded);
    } catch(e) {
      setStateGetListConversations(GetListConversations.error);
      print(e);
    }
  }

  Future sendMessageToConversations(BuildContext context, [List data]) async {
    try { 

      setStateSendMessage(SendMessageStatus.loaded);
    } catch(e) {
      setStateSendMessage(SendMessageStatus.error);
      print(e);
    }
  }

}