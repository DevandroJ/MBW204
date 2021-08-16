import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/feed/sticker.dart';
import 'package:mbw204_club_ina/data/models/feed/comment.dart';
import 'package:mbw204_club_ina/data/models/feed/singlereply.dart';
import 'package:mbw204_club_ina/data/models/feed/notification.dart';
import 'package:mbw204_club_ina/data/models/feed/singlecomment.dart';
import 'package:mbw204_club_ina/data/models/feed/groups.dart';
import 'package:mbw204_club_ina/data/models/feed/singlegroup.dart';
import 'package:mbw204_club_ina/data/models/feed/post.dart';
import 'package:mbw204_club_ina/data/models/feed/mediakey.dart';
import 'package:mbw204_club_ina/data/models/feed/reply.dart';
import 'package:mbw204_club_ina/data/models/feed/all.member.dart';
import 'package:mbw204_club_ina/data/models/feed/groupsmetadata.dart';
import 'package:mbw204_club_ina/data/models/feed/groupsmember.dart';

class FeedService {
  
  static final shared = FeedService();

  Future deletePost(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/post/delete/$postId";
    Response response = await http.delete(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    return response;
  }

  Future<PostModel> fetchPost(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/post/fetch/$postId";
    Response response = await http.get(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    PostModel p = PostModel.fromJson(json.decode(response.body));
    return p;
  }  

  Future<Sticker> fetchListSticker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/sticker/list";
    Response response = await http.get(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    Sticker s = Sticker.fromJson(json.decode(response.body));
    return s;
  }  

  Future<SingleReply> fetchReply(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/reply/fetch/$postId";
    Response response = await http.get(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    SingleReply s = SingleReply.fromJson(json.decode(response.body));
    return s;
  }  

  Future<SingleComment> fetchComment(String targetId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/comment/fetch/$targetId";
    Response response = await http.get(url, 
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    SingleComment c = SingleComment.fromJson(json.decode(response.body));
    return c;
  }  

  Future<Reply> fetchAllReply(String targetId, [String nextCursor = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/reply/list?targetId=$targetId&cursorId=$nextCursor";
    Response response = await http.get(url, 
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      } 
    );
    Reply reply = Reply.fromJson(json.decode(response.body));
    return reply;
  }  

  Future<Notification> fetchAllNotification([String cursorId = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/notification/list?cursorId=$cursorId";
    Response response = await http.get(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    Notification n = Notification.fromJson(json.decode(response.body));
    return n;
  }

  Future fetchAllMember([String nextCursor = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/user/list?cursorId=$nextCursor";
    Response response = await http.get(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    AllMember allMember = AllMember.fromJson(json.decode(response.body));
    return allMember;
  }

  Future fetchGroup(String groupId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/group/fetch/$groupId";
    Response response = await http.get(url, 
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    SingleGroup s = SingleGroup.fromJson(json.decode(response.body));
    return s;
  }

  Future fetchAllGroupsMember(String groupId, [String nextCursor = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/group/members?groupId=$groupId&cursorId=$nextCursor";
    Response response = await http.get(url, 
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    GroupsMember allMember = GroupsMember.fromJson(json.decode(response.body));
    return allMember;
  }

  Future<GroupsMetaData> fetchGroupsMetaData([String nextCursor = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/group/list";
    Response response = await http.get(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    GroupsMetaData groupsMetaDataList = GroupsMetaData.fromJson(json.decode(response.body));
    return groupsMetaDataList;
  }

  Future<Comment> fetchListCommentMostRecent(String targetId, [String nextCursor = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/comment/list?targetType=POST&type=MOST_RECENT&targetId=$targetId&cursorId=$nextCursor";
    Response response = await http.get(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    Comment comment = Comment.fromJson(json.decode(response.body));
    return comment;
  }
  
  Future<GroupsModel> fetchGroupsMostRecent([String nextCursor = ""]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token");
      HttpClient ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      IOClient http = IOClient(ioc);
      String url = "${AppConstants.BASE_URL_FEED}/post/list?type=MOST_RECENT&cursorId=$nextCursor";
      Response response = await http.get(url, 
        headers: {
          "Authorization": "Bearer $token",
          "X-Context-ID": AppConstants.X_CONTEXT_ID
        }
      );
      GroupsModel groupsModel = GroupsModel.fromJson(json.decode(response.body));
      return groupsModel;
    } on FormatException catch(_) {
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
    return GroupsModel();
  }

  Future<GroupsModel> fetchGroupsMostPopular([String nextCursor = ""]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token");
      HttpClient ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      IOClient http = IOClient(ioc);
      String url = "${AppConstants.BASE_URL_FEED}/post/list?type=MOST_POPULAR&cursorId=$nextCursor";
      Response response = await http.get(url, 
        headers: { 
          "Authorization": "Bearer $token",
          "X-Context-ID": AppConstants.X_CONTEXT_ID
        }
      );
      GroupsModel groupsModel = GroupsModel.fromJson(json.decode(response.body));
      return groupsModel;
    } on FormatException catch(_) {
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
    return GroupsModel();
  }

  Future<GroupsModel> fetchGroupsSelf([String nextCursor = ""]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token");
      HttpClient ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      IOClient http = IOClient(ioc);
      String url = "${AppConstants.BASE_URL_FEED}/post/list?type=SELF&cursorId=$nextCursor";
      Response response = await http.get(url,
        headers: {
          "Authorization": "Bearer $token",
          "X-Context-ID": AppConstants.X_CONTEXT_ID
        }
      );
      GroupsModel groupsModel = GroupsModel.fromJson(json.decode(response.body));
      return groupsModel;
    } on FormatException catch(_) {
      throw ServerErrorException(null);
    } catch(e) {
      print(e);
    }
    return GroupsModel();
  }

  Future<GroupsModel> fetchGroupsMostRecentChild(String groupId, [String nextCursor = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/post/list?type=MOST_RECENT&cursorId=$nextCursor&groupId=$groupId";
    Response response = await http.get(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    GroupsModel groupsModel = GroupsModel.fromJson(json.decode(response.body));
    return groupsModel;
  }

  Future<GroupsModel> fetchGroupsMostPopularChild(String groupId, [String nextCursor = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/post/list?type=MOST_POPULAR&cursorId=$nextCursor&groupId=$groupId";
    Response response = await http.get(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    GroupsModel groupsModel = GroupsModel.fromJson(json.decode(response.body));
    return groupsModel;
  }

  Future<GroupsModel> fetchGroupsSelfChild(String groupId, [String nextCursor = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED}/post/list?type=SELF&cursorId=$nextCursor&groupId=$groupId";
    Response response = await http.get(url,
      headers: {
        "Authorization": "Bearer $token",
        "X-Context-ID": AppConstants.X_CONTEXT_ID
      }
    );
    GroupsModel groupsModel = GroupsModel.fromJson(json.decode(response.body));
    return groupsModel;
  }

  Future<String> getMediaKey() async {
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED_MEDIA}/mediaKey";
    Response response = await http.get(url);
    MediaKey mediaKey = MediaKey.fromJson(json.decode(response.body));
    return mediaKey.body;
  }

  Future<Response> uploadMedia(String mediaKey, String base64, File file) async {
    HttpClient ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient http = IOClient(ioc);
    String url = "${AppConstants.BASE_URL_FEED_MEDIA}/$mediaKey/$base64?path=/community/${AppConstants.X_CONTEXT_ID}/${basename(file.path)}";
    Response response = await http.post(url, body: file.readAsBytesSync());
    return response;
  }

  Future<HttpClientResponse> like(String targetId, String targetType, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    String url = '${AppConstants.BASE_URL_FEED}/like/toggle';
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    Map<String, Object> jsonMap = {
      "targetType": targetType,
      "targetId": targetId,
      "type": type
    };
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

  Future<HttpClientResponse> sendPostText(String text, [String groupId = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    String url = '${AppConstants.BASE_URL_FEED}/post/write';
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    Map<String, Object> postsData = {
      "groupId": groupId,
      "visibilityType": "PUBLIC",
      "type": "TEXT",
      "content": {
        "charset": "UTF_8",
        "text": text
      }
    };   
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(postsData)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

  
  Future<HttpClientResponse> sendPostLink(String caption, String text, [String groupId = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    String url = '${AppConstants.BASE_URL_FEED}/post/write';
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    Map<String, Object> postsData = {
      "groupId": groupId,
      "visibilityType": "PUBLIC",
      "type": "LINK",
      "content": {
        "charset": "UTF_8",
        "caption": caption,
        "url": text
      }
    };   
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(postsData)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }



  Future<HttpClientResponse> sendPostDoc(String caption, FilePickerResult files, [String groupId = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    String url = '${AppConstants.BASE_URL_FEED}/post/write';
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    Map<String, Object> postsData = {
      "groupId": groupId,
      "visibilityType": "PUBLIC",
      "type": "DOCUMENT",
      "content" : {
        "caption" : caption,
        "medias": [
          {
            "originalName": basename(files.files[0].path),
            "fileLength": files.files[0].size,
            "path": "/community/${AppConstants.X_CONTEXT_ID}/${basename(files.files[0].path)}",
            "contentType": lookupMimeType(basename(files.files[0].path))
          }
        ]
      }
    };
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(postsData)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

  Future<HttpClientResponse>  sendPostImage(String caption, List<File> files, [String groupId = ""]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token");
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      String url = '${AppConstants.BASE_URL_FEED}/post/write';
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      Map<String, Object> postsData = {};
      List<Map<String, Object>> postsMedia = [];
      if(files.length > 1) {
        for (int i = 0; i < files.length; i++) {
          postsMedia.add(
            {
              "originalName": basename(files[i].path),
              "fileLength": files[i].lengthSync(),
              "path": "/community/${AppConstants.X_CONTEXT_ID}/${basename(files[i].path)}",
              "contentType": lookupMimeType(basename(files[i].path))
            }
          );
        }
        postsData = {
          "groupId": groupId,
          "visibilityType": "PUBLIC",
          "type": "IMAGE",
          "content" : {
            "caption" : caption,
            "medias": postsMedia,
          }
        };
      } else {
        postsData = {
          "groupId": groupId,
          "visibilityType": "PUBLIC",
          "type": "IMAGE",
          "content" : {
            "caption" : caption,
            "medias": [
              {
                "originalName": basename(files[0].path),
                "fileLength": files[0].lengthSync(),
                "path": "/community/${AppConstants.X_CONTEXT_ID}/${basename(files[0].path)}",
                "contentType": lookupMimeType(basename(files[0].path))
              }
            ]
          }
        };
      }
      request.headers.set('Authorization', 'Bearer $token');
      request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(postsData)));
      HttpClientResponse response = await request.close();
      httpClient.close();
      return response;
    } catch(e) {
      print(e);
    }
  }

  Future<HttpClientResponse> sendPostImageCamera(String caption, File file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    String url = '${AppConstants.BASE_URL_FEED}/post/write';
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    Map<String, Object> postsData = {};  
    postsData = {
      "visibilityType": "PUBLIC",
      "type": "IMAGE",
      "content" : {
        "caption" : caption,
        "medias": [
          {
            "originalName": basename(file.path),
            "fileLength": file.lengthSync(),
            "path": "/community/${AppConstants.X_CONTEXT_ID}/${basename(file.path)}",
            "contentType": lookupMimeType(basename(file.path))
          }
        ]
      }
    };
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(postsData)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

  Future<HttpClientResponse> sendPostVideo(String caption, File file, [String groupId = ""]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    String url = '${AppConstants.BASE_URL_FEED}/post/write';
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    Map<String, Object> postsData = {
      "groupId": groupId,
      "visibilityType": "PUBLIC",
      "type": "VIDEO",
      "content" : {
        "caption" : caption,
        "medias": [
          {
            "originalName": basename(file.path),
            "fileLength": file.lengthSync(),
            "path": "/community/${AppConstants.X_CONTEXT_ID}/${basename(file.path)}",
            "contentType": lookupMimeType(basename(file.path))
          }
        ]
      }
    };
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(postsData)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

  Future<HttpClientResponse> addGroup(String desc, String name, [File fileProfile, File fileBackground]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    String url = '${AppConstants.BASE_URL_FEED}/group/save';
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    Map<String, Object> jsonMap = {};
   if(fileProfile?.path != null) {
      jsonMap = {
        "description": desc,
        "name": name,
        "type": "PRIVATE",
        "profilePic": {
          "contentType": lookupMimeType(basename(fileProfile.path)),
          "fileLength": await fileProfile.length(),
          "kind": "IMAGE",
          "originalName": basename(fileProfile.path),
          "path": "/community/${AppConstants.X_CONTEXT_ID}/${basename(fileProfile.path)}"
        },
      };
   }
   if(fileBackground?.path != null) {
     jsonMap = {
        "description": desc,
        "name": name,
        "type": "PRIVATE",
        "background": {
          "contentType": lookupMimeType(basename(fileBackground.path)),
          "fileLength": await fileBackground.length(),
          "kind": "IMAGE",
          "originalName": basename(fileBackground.path),
          "path": "/community/210232917031/${basename(fileBackground.path)}"
        },
      };
   }
    jsonMap = {
      "description": desc,
      "name": name,
      "type": "PRIVATE",
    };
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

  Future<HttpClientResponse> updateGroup(String groupId, String desc, String name, [File fileProfile, File fileBackground]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    String url = '${AppConstants.BASE_URL_FEED}/group/update';
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    Map<String, Object> jsonMap;
    if(fileProfile?.path != null) {
      jsonMap = {
        "groupId" : groupId,
        "description": desc,
        "name": name,
        "type": "PRIVATE",
        "profilePic": {
          "contentType": lookupMimeType(basename(fileProfile.path)),
          "fileLength": await fileProfile.length(),
          "kind": "IMAGE",
          "originalName": basename(fileProfile.path),
          "path": "/community/${AppConstants.X_CONTEXT_ID}/${basename(fileProfile.path)}"
        },
      };
    } else if(fileBackground?.path != null) {
      jsonMap = {
        "groupId" : groupId,
        "description": desc,
        "name": name,
        "type": "PRIVATE",
        "background": {
          "contentType": lookupMimeType(basename(fileBackground.path)),
          "fileLength": await fileBackground.length(),
          "kind": "IMAGE",
          "originalName": basename(fileBackground.path),
          "path": "/community/${AppConstants.X_CONTEXT_ID}/${basename(fileBackground.path)}"
        },
      };
    } else {
      jsonMap = {
        "groupId" : groupId,
        "description": desc,
        "name": name,
        "type": "PRIVATE",
      };
    }
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

  Future<HttpClientResponse> sendReply(String text, String targetId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    String url = '${AppConstants.BASE_URL_FEED}/reply/write';
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    Map<String, Object> postsData = {
      "targetId": targetId,
      "type": "TEXT",
      "content" : {
        "text" : text
      }
    };
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(postsData)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

  Future<HttpClientResponse> sendComment(String text, String targetId, [String urlParam = "", String type = "TEXT"]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    String url = '${AppConstants.BASE_URL_FEED}/comment/write';
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    Map<String, Object> data = {};
    if(type == "TEXT") {
      data = {
        "targetType": "POST",
        "targetId": targetId,
        "visibilityType" : "FRIENDS",
        "type" : type,
        "content" : {
          "text" : text
        }
      };
    }
    if(type == "STICKER") {
      data = {
        "targetType": "POST",
        "targetId": targetId,
        "visibilityType" : "FRIENDS",
        "type" : type,
        "content" : {
          "url" : urlParam
        }
      };
    }
  
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('X-Context-ID', AppConstants.X_CONTEXT_ID);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

}