import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import 'package:mbw204_club_ina/data/models/chat/list_chat.dart';
import 'package:mbw204_club_ina/data/models/chat/list_conversation.dart';
import 'package:mbw204_club_ina/data/models/chat/response_send_message.dart';
import 'package:mbw204_club_ina/data/repository/chat.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

enum GetChatStatus { idle, loading, loaded, error, isEmpty }
enum GetListConversations { idle, loading, loaded, error, isEmpty }
enum SendMessageStatus { idle, loading, loaded, error, isEmpty }
enum SendMessageStatusConfirm { idle, loading, loaded, error, isEmpty }

class ChatProvider with ChangeNotifier {
  final ChatRepo chatRepo;
  final SharedPreferences sharedPreferences;
  ChatProvider({
    this.chatRepo,
    this.sharedPreferences
  });

  Soundpool pool = Soundpool(
    streamType: StreamType.notification
  );

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
      List<ListChatData> lcd = await chatRepo.fetchListChat(context);
      _listChatData = lcd;
      setStateGetChatStatus(GetChatStatus.loaded);
      if(_listChatData.length != lcd.length) {
        _listChatData.clear();
        _listChatData.addAll(lcd);
        setStateGetChatStatus(GetChatStatus.loaded);
      }
      if(_listChatData.isEmpty) {
        setStateGetChatStatus(GetChatStatus.isEmpty);
      }
    } catch(e) {
      setStateGetChatStatus(GetChatStatus.error);
      print(e);
    }
  }

  Future fetchListConversations(BuildContext context, String groupId) async {
    try {
      List<ListConversationData> lcd = await chatRepo.fetchListConversations(context, groupId);
      _listConversationData = lcd;
      setStateGetListConversations(GetListConversations.loaded);
      if(_listConversationData.length != lcd.length) {
        _listConversationData.clear();
        _listConversationData.addAll(lcd);
        setStateGetListConversations(GetListConversations.loaded);
      }
      setStateGetListConversations(GetListConversations.loaded);
    } catch(e) {
      setStateGetListConversations(GetListConversations.error);
      print(e);
    }
  }

  Future sendMessageToConversations(BuildContext context, String text, ListChatData listChatData, [dynamic data]) async {
    try { 
      ResponseSendMessageConversationModelData responseSendMessageConversationModelData = await chatRepo.sendMessageToConversations(context, text, listChatData.identity);
      if(sharedPreferences.getString("userId") != listChatData.userId) {
        _listConversationData.insert(0, ListConversationData(
          id: responseSendMessageConversationModelData.conversationId,
          contextId: AppConstants.X_CONTEXT_ID,
          replyToConversationId: null,
          created: DateTime.now().toString(),
          fromMe: true,
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
        Timer(Duration(milliseconds: 200),() => scrollController.jumpTo(scrollController.position.maxScrollExtent));
        await loadSound();
        fetchListChat(context);
      }
      setStateSendMessage(SendMessageStatus.loaded);
    } catch(e) {
      setStateSendMessage(SendMessageStatus.error);
      print(e);
    }
  }

  Future sendMessageToConversationsSocket(BuildContext context, dynamic data) async {
    try { 
      _listConversationData.insert(0, ListConversationData(
        id: data["id"],
        replyToConversationId: data["payload"]["replyToConversationId"],
        created: DateTime.now().toString(),
        fromMe: false,
        contextId: AppConstants.X_CONTEXT_ID,
        group: data["payload"]["group"],
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
          userId: data["payload"]["remote"]["userId"],
          identity: data["payload"]["remote"]["identity"],
          displayName: data["payload"]["remote"]["displayName"],
          group: data["payload"]["remote"]["group"],
          classId: data["payload"]["remote"]["classId"],
          profilePic: ListConversationProfilePic(
            originalName: data["payload"]["remote"]["profilePic"]["originalName"],
            path: data["payload"]["remote"]["profilePic"]["originalName"],
            fileLength: data["payload"]["remote"]["profilePic"]["fileLength"],
            contentType: data["payload"]["remote"]["profilePic"]["contentType"],
            kind: data["payload"]["remote"]["profilePic"]["kind"]
          )
        ),
        messageStatus: "SENT",
        type: data["payload"]["type"],
        classId: data["payload"]["classId"],
        content: Content(
          charset: data["payload"]["content"]["charset"],
          text: data["payload"]["content"]["text"]
        )
      ));
      Timer(Duration(milliseconds: 200),() => scrollController.jumpTo(scrollController.position.maxScrollExtent));
      await loadSound();
      fetchListChat(context);
      setStateSendMessageStatusConfirm(SendMessageStatusConfirm.loaded);
    } catch(e) {
      setStateSendMessageStatusConfirm(SendMessageStatusConfirm.error);
      print(e);
    }
  }

  Future<int> loadSound() async {
    var asset = await rootBundle.load("assets/sounds/sent.mp3");
    return await pool.play(await pool.load(asset));
  }

}