import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/repository/feed.dart';
import 'package:mbw204_club_ina/container.dart';

class SocketHelper {
  static final shared = SocketHelper();
  IO.Socket socket;

  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");   
    socket = IO.io('${AppConstants.BASE_URL_SOCKET_FEED}', <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true,
      'autoConnect': false,
    });
    socket.io.options['extraHeaders'] = {
      'X-Token': token,
      'X-Context-ID': AppConstants.X_CONTEXT_ID
    };
    socket.connect();
    socket.on("connect", (data) {
      print('=== Connected to Socket ===');
      socket.on("messages", (data) async {
        if(data["payload"]["activity"] == "COMMENT") {
          getIt<FeedState>().addComment(data);
        }
        if(data["payload"]["activity"] == "REPLY") {
          getIt<FeedState>().addReply(data);
        }
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