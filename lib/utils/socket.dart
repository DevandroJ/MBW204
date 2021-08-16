import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/helpers/random_string.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/repository/feed.dart';
import 'package:mbw204_club_ina/container.dart';

class SocketHelper {
  static final shared = SocketHelper();
  IO.Socket socket;

  void connect(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");   
    socket = IO.io('${AppConstants.SWITCH_TO_CHAT_BASE_URL}', <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'forceNew': true,
      'autoConnect': false,
    });
    socket.io.options['extraHeaders'] = {
      'X-Token': token,
      'X-Context-ID': AppConstants.X_CONTEXT_ID
    };
    socket.connect();
    socket.on("connect", (data) async {
      print('=== SOCKET CONNECT ===');
      socket.on("messages", (data) async {
        print(data);
        final res = data as dynamic; 
        if(res is List) {
          if(res[0]["action"] == "CHAT_CONVERSATION") {
            Future.delayed(Duration.zero, () async {
              await Provider.of<ChatProvider>(context, listen: false).sendMessageToConversationsSocket(context, res[0]);
            });
            final dataList = data as List;
            final ack = dataList.last as Function;
            String encode = json.encode({
              "id": getRandomString(16),
              "replyToId": res[0]["id"],
              "timestamp": DateTime.now().millisecondsSinceEpoch,
              "event": "ACK",
              "action": "CHAT_CONVERSATION",
              "payload": {
                "code": 0,
                "message": "Successfully"
              }
            });
            ack(encode);
          }
        }
        
        // await Provider.of<ChatProvider>(context, listen: false).fetchListConversations(context, data[0]["id"]);
        // if(data["payload"]["activity"] == "COMMENT") {
        //   getIt<FeedState>().addComment(data);
        // }
        // if(data["payload"]["activity"] == "REPLY") {
        //   getIt<FeedState>().addReply(data);
        // }
      });
    });
  }
  
  Future sendCommentMostRecent(String text, String targetId, [String url ="", String type = "TEXT"]) async {
    await FeedService.shared.sendComment(text, targetId, url, type);
    getIt<FeedState>().fetchListCommentMostRecent(targetId);
  }

  Future sendReply(String text, String targetId, String postId) async {
    await FeedService.shared.sendReply(text, targetId);
    if(postId != null)
      getIt<FeedState>().fetchListCommentMostRecent(postId);
  }

}