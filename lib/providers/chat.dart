import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import 'package:mbw204_club_ina/maps/src/utils/uuid.dart';
import 'package:mbw204_club_ina/data/models/chat/list_chat.dart';
import 'package:mbw204_club_ina/data/models/chat/list_conversation.dart';
import 'package:mbw204_club_ina/data/repository/chat.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

enum ListChatStatus { idle, loading, loaded, refetch, error, empty }
enum ListConversationsStatus { idle, loading, loaded, error, empty }
enum SendMessageStatus { idle, loading, loaded, error, empty }
enum SendMessageStatusConfirm { idle, loading, loaded, error, empty }

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

  String conversationIdGenerated = Uuid().generateV4();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  TextEditingController inputMsgController = TextEditingController();
  ScrollController scrollController = ScrollController();   

  ListConversationsStatus _listConversationsStatus = ListConversationsStatus.loading;
  ListConversationsStatus get listConversationsStatus =>  _listConversationsStatus;

  ListChatStatus _listChatStatus = ListChatStatus.loading;
  ListChatStatus get listChatStatus => _listChatStatus;

  SendMessageStatus _sendMessageStatus = SendMessageStatus.loading;
  SendMessageStatus get sendMessageStatus => _sendMessageStatus;
  
  SendMessageStatusConfirm _sendMessageStatusConfirm = SendMessageStatusConfirm.loading;
  SendMessageStatusConfirm get sendMessageStatusConfirm => _sendMessageStatusConfirm;

  List<ListConversationData> _listConversationData = [];
  List<ListConversationData> get listConversationsData => [..._listConversationData];

  List<ListChatData> _listChatData = [];
  List<ListChatData> get listChatData => [..._listChatData];

  void setStateListConversationsStatus(ListConversationsStatus listConversationsStatus) {
    _listConversationsStatus = listConversationsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateListChatStatus(ListChatStatus listChatStatus) {
    _listChatStatus = listChatStatus;
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
      if(_listChatData.length != lcd.length || listChatStatus == ListChatStatus.refetch) {
        _listChatData.clear();
        _listChatData.addAll(lcd);
        setStateListChatStatus(ListChatStatus.loaded);
        if(_listChatData.isEmpty) {
          setStateListChatStatus(ListChatStatus.empty);
        }
      }
    } catch(e) {
      setStateListChatStatus(ListChatStatus.error);
      print(e);
    }
  }

  Future fetchListConversations(BuildContext context, String groupId) async {
    try {
      List<ListConversationData> lcd = await chatRepo.fetchListConversations(context, groupId);
      if(_listConversationData.length != lcd.length) {
        _listConversationData.clear();
        _listConversationData.addAll(lcd);
        setStateListConversationsStatus(ListConversationsStatus.loaded);
        if(_listConversationData.isEmpty) {
          setStateListConversationsStatus(ListConversationsStatus.empty);
        }
      }
    } catch(e) {
      setStateListConversationsStatus(ListConversationsStatus.error);
      print(e);
    }
  }

  Future sendMessageToConversations(BuildContext context, String text, ListChatData listChatData) async {
    try { 
      if(sharedPreferences.getString("userId") != listChatData.userId) {
        _listConversationData.insert(0, ListConversationData(
          id: conversationIdGenerated,
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
          messageStatus: "DELIVERED",
          type: "TEXT",
          classId: "oconversation",
          content: Content(
            charset: "UTF_8",
            text: inputMsgController.text
          )
        ));
        Timer(Duration(milliseconds: 200),() => scrollController.jumpTo(scrollController.position.maxScrollExtent));
        await loadSoundSent();
      }
      fetchListChat(context);
      setStateListChatStatus(ListChatStatus.refetch);
      inputMsgController.text = "";
      int index = _listConversationData.indexWhere((el) => el.id == conversationIdGenerated);
      await chatRepo.sendMessageToConversations(context, text, listChatData.identity);
      _listConversationData[index].messageStatus = "SENT";
      setStateSendMessage(SendMessageStatus.loaded);
    } on Error catch(_) {
      int index = _listConversationData.indexWhere((el) => el.id == conversationIdGenerated);
      _listConversationData[index].messageStatus = "UNDELIVERED";
      inputMsgController.text = _listConversationData[index].content.text;
      text = _listConversationData[index].content.text;
      setStateSendMessage(SendMessageStatus.error);
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
      await loadSoundSent();
      notifyChat(context, data);
      fetchListChat(context);
      setStateListChatStatus(ListChatStatus.refetch);
      setStateSendMessageStatusConfirm(SendMessageStatusConfirm.loaded);
    } catch(e) {
      setStateSendMessageStatusConfirm(SendMessageStatusConfirm.error);
      print(e);
    }
  }

  Future<int> loadSoundSent() async {
    var asset = await rootBundle.load("assets/sounds/sent.mp3");
    return await pool.play(await pool.load(asset));
  }

  Future ackRead(BuildContext context, String chatId) async {
    try {
      await chatRepo.ackRead(context, chatId);
    } catch(e) {
      print(e);
    }
  }

  Future notifyChat(BuildContext context, [dynamic data]) async {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    if(basket["state"] == AppLifecycleState.paused){ 
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('BroadcastID', 'Broadcast', 'Broadcast',
        priority: Priority.high,
        importance: Importance.max,
        enableLights: true,
        playSound: true,
        enableVibration: true,
      );
      IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, data["payload"]["remote"]["displayName"], data["payload"]["content"]["text"], notificationDetails);
    }
  }

}