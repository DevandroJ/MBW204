import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/data/models/chat_message.dart';

enum ChatStatus { idle, loading, loaded, isEmpty }

class ChatProvider with ChangeNotifier {

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