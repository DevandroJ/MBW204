import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/data/models/chat_message.dart';
import 'package:mbw204_club_ina/data/models/chat/list_conversation.dart';
import 'package:mbw204_club_ina/data/repository/chat.dart';

enum ChatStatus { idle, loading, loaded, isEmpty }
enum GetListConversations { idle, loading, loaded, isEmpty }

class ChatProvider with ChangeNotifier {
  final ChatRepo chatRepo;
  ChatProvider({
    this.chatRepo
  });

  GetListConversations _getListConversations = GetListConversations.loading;
  GetListConversations get getListConversations =>  _getListConversations;

  List<ListConversationData> _listConversationData = [];
  List<ListConversationData> get listConversationsData => [..._listConversationData];

  void setStateGetListConversations(GetListConversations getListConversations) {
    _getListConversations = getListConversations;
    Future.delayed(Duration.zero, () => notifyListeners());
  }


  Future fetchListConversations(BuildContext context) async {
    try {
      List<ListConversationData> listConversationData = await chatRepo.fetchListConversations(context);
      if(listConversationsData != null || listConversationsData.isNotEmpty) {
        if(listConversationData.length != _listConversationData.length) {
          _listConversationData.clear();
          _listConversationData.addAll(listConversationData);
        }
        print(listConversationData);
        setStateGetListConversations(GetListConversations.loaded);
      } else {
        setStateGetListConversations(GetListConversations.isEmpty);
      }
    } catch(e) {
      print(e);
    }
  }

  List<ChatMessage> _chatMessage = [
    ChatMessage(
      isSender: false,
      text: "Hello John"
    ),
    ChatMessage(
      isSender: false,
      text: "P"
    ),
  ];

  List<ChatMessage> get chatMessage => [..._chatMessage];

  fetchMessage() {
   
  }

  sendMessage(String msg) {
    _chatMessage.add(
      ChatMessage(
        isSender: true,
        text: msg
      )
    );
    notifyListeners();
  }

}