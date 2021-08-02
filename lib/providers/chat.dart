import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/data/models/chat/list_chat.dart';
import 'package:mbw204_club_ina/data/models/chat/list_conversation.dart';
import 'package:mbw204_club_ina/data/models/chat/response_send_message.dart';
import 'package:mbw204_club_ina/data/repository/chat.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

enum GetChatStatus { idle, loading, loaded, error, isEmpty }
enum GetListConversations { idle, loading, loaded, error, isEmpty }
enum SendMessageStatus { idle, loading, loaded, error, isEmpty }
enum SendMessageStatusConfirm { idle, loading, loaded, erorr, isEmpty }

class ChatProvider with ChangeNotifier {
  final ChatRepo chatRepo;
  final SharedPreferences sharedPreferences;
  ChatProvider({
    this.chatRepo,
    this.sharedPreferences
  });

  ScrollController scrollController = ScrollController(); 

  GetListConversations _getListConversations = GetListConversations.loading;
  GetListConversations get getListConversations =>  _getListConversations;

  GetChatStatus _getChatStatus = GetChatStatus.loading;
  GetChatStatus get getChatStatus => _getChatStatus;

  SendMessageStatus _sendMessageStatus = SendMessageStatus.loading;
  SendMessageStatus get sendMessageStatus => _sendMessageStatus;
  
  SendMessageStatusConfirm _sendMessageStatusConfirm = SendMessageStatusConfirm.loading;
  SendMessageStatusConfirm get sendMessageStatusConfirm => _sendMessageStatusConfirm;

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

  void setStateSendMessageStatusConfirm(SendMessageStatusConfirm sendMessageStatusConfirm) {
    _sendMessageStatusConfirm = sendMessageStatusConfirm;
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

  Future sendMessageToConversations(BuildContext context, String text, ListChatData listChatData) async {
    try { 
      ResponseSendMessageConversationModelData responseSendMessageConversationModelData = await chatRepo.sendMessageToConversations(context, text, listChatData.identity);
      _listConversationData.insert(0, ListConversationData(
        id: responseSendMessageConversationModelData.conversationId,
        replyToConversationId: null,
        fromMe: true,
        contextId: AppConstants.X_CONTEXT_ID,
        group: false,
        origin: Origin(
          userId: sharedPreferences.getString("userId"),
          identity: sharedPreferences.getString("phoneNumber"),
          displayName: sharedPreferences.getString("userName"),
          group: false,
          classId: "ojidinfo",
          profilePic: ListConversationProfilePic(
            originalName: "",
            path: "",
            fileLength: 0,
            contentType: "image/jpeg",
            kind: "IMAGE"
          )
        ),
        remote: Origin(
          userId: listChatData.userId,
          identity: listChatData.identity,
          displayName: listChatData.displayName,
          group: false,
          classId: "ojidinfo",
          profilePic: ListConversationProfilePic(
            path: listChatData.profilePic.path,
            originalName: listChatData.profilePic.originalName,
            fileLength: listChatData.profilePic.fileLength,
            contentType: listChatData.profilePic.contentType,
            kind: listChatData.profilePic.kind
          )
        ),
        messageStatus: "SENT",
        type: "TEXT",
        classId: "oconversation",
        content: Content(
          charset: "UTF_8",
          text: text
        )
      ));
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      fetchListChat(context);
      setStateSendMessage(SendMessageStatus.loaded);
    } catch(e) {
      setStateSendMessage(SendMessageStatus.error);
      print(e);
    }
  }

  Future sendMessageToConversationsSocket(BuildContext context) {
    try {
      
      setStateSendMessageStatusConfirm(SendMessageStatusConfirm.loaded);
    } catch(e) {
      print(e);
    }
  }
}