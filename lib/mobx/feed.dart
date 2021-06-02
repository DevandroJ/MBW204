import 'dart:convert';
import 'dart:io';

import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mobx/mobx.dart';
import 'package:file_picker/file_picker.dart';

import 'package:mbw204_club_ina/data/repository/feed.dart';
import 'package:mbw204_club_ina/data/models/feed/feedmedia.dart';
import 'package:mbw204_club_ina/data/models/feed/feedposttype.dart';
import 'package:mbw204_club_ina/data/models/feed/singlereply.dart';
import 'package:mbw204_club_ina/data/models/feed/sticker.dart';
import 'package:mbw204_club_ina/data/models/feed/groups.dart';
import 'package:mbw204_club_ina/data/models/feed/all.member.dart';
import 'package:mbw204_club_ina/data/models/feed/post.dart';
import 'package:mbw204_club_ina/data/models/feed/feedlike.dart';
import 'package:mbw204_club_ina/data/models/feed/notification.dart';
import 'package:mbw204_club_ina/data/models/feed/comment.dart';
import 'package:mbw204_club_ina/data/models/feed/singlecomment.dart';
import 'package:mbw204_club_ina/data/models/feed/reply.dart';
import 'package:mbw204_club_ina/data/models/feed/groupsmetadata.dart';
import 'package:mbw204_club_ina/data/models/feed/groupsmember.dart';
import 'package:mbw204_club_ina/data/models/feed/singlegroup.dart';

part 'feed.g.dart';

class FeedState = FeedVM with _$FeedState;

enum AllMemberStatus { loading, loaded, empty }
enum NotificationStatus { loading, loaded, empty }
enum PostStatus { loading, loaded, empty }

enum CommentMostRecentStatus { loading, loaded, empty }
enum CommentMostPopularStatus { loading, loaded, empty }
enum CommentSelfStatus { loading, loaded, empty }

enum SingleReplyStatus { loading, loaded, empty } 
enum SingleCommentStatus { loading, loaded, empty }
enum SingleGroupStatus { loading, loaded, empty }
enum ReplyStatus { loading, loaded, empty }  

enum StickerStatus { loading, loaded, empty } 

enum GroupsMostRecentStatus { loading, loaded, error, empty }
enum GroupsMostPopularStatus { loading, loaded, error, empty }
enum GroupsSelfStatus { loading, loaded, error, empty }

enum GroupsMostRecentStatusC { loading, loaded, empty }
enum GroupsMostPopularStatusC { loading, loaded, empty }
enum GroupsSelfStatusC { loading, loaded, empty }

enum GroupsMemberStatus { loading, loaded, empty }
enum GroupsMetaDataStatus { loading, loaded, empty }

abstract class FeedVM with Store {

  @observable
  NotificationStatus notificationStatus = NotificationStatus.loading;

  @observable
  AllMemberStatus allMemberStatus = AllMemberStatus.loading;

  @observable
  GroupsMemberStatus groupsMemberStatus = GroupsMemberStatus.loading;

  @observable
  PostStatus postStatus = PostStatus.loading;

  @observable
  CommentMostRecentStatus commentMostRecentStatus = CommentMostRecentStatus.loading;

  @observable 
  StickerStatus stickerStatus = StickerStatus.loading;

  @observable
  SingleCommentStatus singleCommentStatus = SingleCommentStatus.loading;

  @observable
  SingleGroupStatus singleGroupStatus = SingleGroupStatus.loading;

  @observable 
  ReplyStatus replyStatus = ReplyStatus.loading;

  @observable
  SingleReplyStatus singleReplyStatus = SingleReplyStatus.loading;

  @observable 
  Notification notification; 

  @observable
  GroupsMostRecentStatusC groupsMostRecentStatusC = GroupsMostRecentStatusC.loading;

  @observable
  GroupsMostPopularStatusC groupsMostPopularStatusC = GroupsMostPopularStatusC.loading;

  @observable
  GroupsSelfStatusC groupsSelfStatusC = GroupsSelfStatusC.loading;

  @observable
  GroupsMostRecentStatus groupsMostRecentStatus = GroupsMostRecentStatus.loading;

  @observable
  GroupsMostPopularStatus groupsMostPopularStatus = GroupsMostPopularStatus.loading;

  @observable 
  GroupsSelfStatus groupsSelfStatus = GroupsSelfStatus.loading;

  @observable
  GroupsMetaDataStatus groupsMetaDataStatus = GroupsMetaDataStatus.loading;

  @observable
  ObservableList<AllMemberBody> allMemberList = ObservableList<AllMemberBody>();

  @observable
  ObservableList<GroupsMemberBody> groupsMemberList = ObservableList<GroupsMemberBody>();

  @observable
  ObservableList<NotificationBody> notificationList = ObservableList<NotificationBody>();

  @observable
  ObservableList<GroupsBody> g1ListC = ObservableList<GroupsBody>();

  @observable
  ObservableList<GroupsBody> g2ListC = ObservableList<GroupsBody>();

  @observable
  ObservableList<GroupsBody> g3ListC = ObservableList<GroupsBody>();

  @observable
  ObservableList<GroupsBody> g1List = ObservableList<GroupsBody>();

  @observable
  ObservableList<GroupsBody> g2List = ObservableList<GroupsBody>();

  @observable
  ObservableList<GroupsBody> g3List = ObservableList<GroupsBody>();

  @observable
  ObservableList<GroupsMetaDataListBody> groupsMetaDataList = ObservableList<GroupsMetaDataListBody>();

  @observable
  ObservableList<CommentBody> c1List = ObservableList<CommentBody>();

  @observable
  ObservableList<CommentBody> c2List = ObservableList<CommentBody>();

  @observable
  ObservableList<CommentBody> c3List = ObservableList<CommentBody>();

  @observable
  ObservableList<ReplyBody> replyList = ObservableList<ReplyBody>();

  @observable
  AllMember allMember;

  @observable 
  SingleGroup singleGroup;

  @observable
  GroupsMember groupsMember;

  @observable
  PostModel post;

  @observable
  Reply reply;
  
  @observable
  SingleComment singleComment;

  @observable
  SingleReply singleReply;

  @observable
  Comment c1;

  @observable
  Comment c2;

  @observable
  Comment c3;

  @observable
  Sticker sticker;

  @observable
  GroupsModel g1child;

  @observable
  GroupsModel g2child;

  @observable
  GroupsModel g3child;

  @observable
  GroupsModel g1;

  @observable
  GroupsModel g2;

  @observable
  GroupsModel g3;

  @observable
  GroupsMetaData groupsMetaData;
  
  @action 
  Future fetchListSticker() async {
    Sticker s = await FeedService.shared.fetchListSticker();
    sticker = s;
    stickerStatus = StickerStatus.loaded;
    if(sticker == null) {
      stickerStatus = StickerStatus.empty;        
    }
  }

  @action 
  Future deletePost(String postId) async {
    try {
      await FeedService.shared.deletePost(postId);
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecent();
        fetchGroupsMostPopular();
        fetchGroupsSelf();
      });
    } catch(e) {
      print(e);
    }
  }

  @action
  Future fetchPost(String postId) async {
    postStatus = PostStatus.loading;
    PostModel p = await FeedService.shared.fetchPost(postId);
    post = p;
    postStatus = PostStatus.loaded;
    if(post == null) {
      postStatus = PostStatus.empty;
    }
  }

  @action
  Future fetchReply(String replyId) async {
    SingleReply s = await FeedService.shared.fetchReply(replyId);
    singleReply = s;
    singleReplyStatus = SingleReplyStatus.loaded;
    if(singleReply == null) {
      singleReplyStatus = SingleReplyStatus.empty;
    }
  }

  @action
  Future fetchComment(String targetId) async {
    SingleComment s = await FeedService.shared.fetchComment(targetId);
    singleComment = s;
    singleCommentStatus = SingleCommentStatus.loaded;
    if(singleComment == null) {
      singleCommentStatus = SingleCommentStatus.empty;
    }
  }

  @action
  Future fetchGroup(String groupId) async {
    SingleGroup s = await FeedService.shared.fetchGroup(groupId);
    singleGroup = s;
    singleGroupStatus = SingleGroupStatus.loaded;
    if(singleGroup == null) {
      singleGroupStatus = SingleGroupStatus.empty;
    }
  }

  @action 
  Future fetchAllNotification() async {
    Notification n = await FeedService.shared.fetchAllNotification();
    notification = n;
    notificationStatus = NotificationStatus.loaded;
    if(notification.body.isNotEmpty) {
      notificationList.clear();
      notificationList.addAll(ObservableList.of(notification.body));
    } else {
      notificationStatus = NotificationStatus.empty;
    }
  }

  @action 
  Future fetchAllNotificationLoad(String nextCursor) async {
    Notification n = await FeedService.shared.fetchAllNotification(nextCursor);
    notification = n;
    notificationList.clear();
    notificationList.addAll(ObservableList.of(notification.body));
    notificationStatus = NotificationStatus.loaded;
  }
  
  @action
  Future fetchAllReply(String targetId)  async {
    Reply r = await FeedService.shared.fetchAllReply(targetId);
    reply = r;
    replyStatus = ReplyStatus.loaded;
    if(reply.body.isNotEmpty) {
      replyList = ObservableList.of(reply.body);
    } else {
      replyStatus = ReplyStatus.empty;
    }
  }

  @action
  Future fetchAllReplyLoad(String targetId, [String nextCursor = ""])  async {
    Reply r = await FeedService.shared.fetchAllReply(targetId, nextCursor);
    reply = r;
    replyList.addAll(ObservableList.of(r.body));
    replyStatus = ReplyStatus.loaded;
  }

  @action
  Future fetchListCommentMostRecent(String targetId) async {
    Comment c = await FeedService.shared.fetchListCommentMostRecent(targetId);
    c1 = c;
    commentMostRecentStatus = CommentMostRecentStatus.loaded;
    if(c1.body.isNotEmpty) {
      c1List.clear();
      c1List.addAll(ObservableList.of(c1.body));
    } else {
      commentMostRecentStatus = CommentMostRecentStatus.empty;
    }
  }

  @action
  Future fetchListCommentMostRecentLoad(String targetId, [String nextCursor = ""]) async {
    Comment c = await FeedService.shared.fetchListCommentMostRecent(targetId, nextCursor);
    c1 = c;
    c1List.addAll(ObservableList.of(c.body));
    commentMostRecentStatus = CommentMostRecentStatus.loaded;
  }
  
  @action
  Future fetchAllMember() async {
    AllMember a = await FeedService.shared.fetchAllMember();
    allMember = a;
    if(a.body.isNotEmpty) {
      allMemberList = ObservableList.of(a.body);
      allMemberStatus = AllMemberStatus.loaded;
    } else {
      allMemberStatus = AllMemberStatus.empty;
    }
  }

  @action
  Future fetchAllMemberLoad(String nextCursor) async {
    AllMember a = await FeedService.shared.fetchAllMember(nextCursor);
    allMember = a;
    allMemberList.addAll(ObservableList.of(a.body));
    allMemberStatus = AllMemberStatus.loaded;
  }

  @action
  Future fetchAllGroupsMember(String groupId) async {
    GroupsMember g = await FeedService.shared.fetchAllGroupsMember(groupId);
    groupsMember = g;
    if(g.body.isNotEmpty) {
      groupsMemberList = ObservableList.of(g.body);
      groupsMemberStatus = GroupsMemberStatus.loaded;
    } else {
      groupsMemberStatus = GroupsMemberStatus.empty;
    }
  }

  @action
  Future fetchGroupsMostRecentChild(String groupId) async { 
    GroupsModel g = await FeedService.shared.fetchGroupsMostRecentChild(groupId);
    g1child = g;
    if(g.body.isNotEmpty) {
      g1ListC = ObservableList.of(g.body);
      groupsMostRecentStatusC = GroupsMostRecentStatusC.loaded;   
    } else {
      groupsMostRecentStatusC = GroupsMostRecentStatusC.empty;   
    }
  }

  @action
  Future fetchGroupsMostPopularChild(String groupId) async {
    GroupsModel g = await FeedService.shared.fetchGroupsMostPopularChild(groupId);
    g2child = g;
    if(g.body.isNotEmpty) {
      g2ListC.clear();
      g2ListC.addAll(ObservableList.of(g.body));
      groupsMostPopularStatusC = GroupsMostPopularStatusC.loaded;   
    } else {
      groupsMostPopularStatusC = GroupsMostPopularStatusC.empty;   
    }
  }

  @action
  Future fetchGroupsSelfChild(String groupId) async {
    GroupsModel g = await FeedService.shared.fetchGroupsSelfChild(groupId);
    g3child = g;
    if(g.body.isNotEmpty) {
      g3ListC = ObservableList.of(g.body);
      groupsSelfStatusC = GroupsSelfStatusC.loaded;   
    } else {
       groupsSelfStatusC = GroupsSelfStatusC.empty;   
    }
  }

  @action
  Future fetchGroupsMostRecentChildLoad(String groupId, [String nextCursor = ""]) async { 
    GroupsModel g = await FeedService.shared.fetchGroupsMostRecentChild(groupId, nextCursor);
    g1child = g; 
    g1ListC.addAll(ObservableList.of(g.body));
    groupsMostRecentStatusC = GroupsMostRecentStatusC.loaded;   
  }

  @action
  Future fetchGroupsMostPopularChildLoad(String groupId, [String nextCursor = ""]) async {
    GroupsModel g = await FeedService.shared.fetchGroupsMostPopularChild(groupId, nextCursor);
    g2child = g;
    g2ListC.addAll(ObservableList.of(g.body));
    groupsMostPopularStatusC = GroupsMostPopularStatusC.loaded;   
  }

  @action
  Future fetchGroupsSelfChildLoad(String groupId, [String nextCursor = ""]) async {
    GroupsModel g = await FeedService.shared.fetchGroupsSelfChild(groupId, nextCursor);
    g3child = g;
    g3ListC.addAll(ObservableList.of(g.body));
    groupsSelfStatusC = GroupsSelfStatusC.loaded;   
  }

  @action
  Future fetchGroupsMostRecent() async {
    try {
      GroupsModel g = await FeedService.shared.fetchGroupsMostRecent();
      g1 = g;
      if (g1.body.isNotEmpty) {
        g1List.clear();
        g1List.addAll(ObservableList.of(g.body));     
        groupsMostRecentStatus = GroupsMostRecentStatus.loaded;
      } else {
        groupsMostRecentStatus = GroupsMostRecentStatus.empty;
      } 
    } on ServerErrorException catch(_) {
      groupsMostRecentStatus = GroupsMostRecentStatus.error;
    } catch(e) {
      print(e);
    } 
  }

  @action 
  Future fetchGroupsMostPopular() async {
    try {
      GroupsModel g = await FeedService.shared.fetchGroupsMostPopular();
      g2 = g;
      if(g2.body.isNotEmpty) {
        g2List.clear();
        g2List.addAll(ObservableList.of(g.body));
        groupsMostPopularStatus = GroupsMostPopularStatus.loaded;
      } else {
        groupsMostPopularStatus = GroupsMostPopularStatus.empty;
      }
    } on ServerErrorException catch(_) {
      groupsMostPopularStatus = GroupsMostPopularStatus.error;
    } catch(e) {
      print(e);
    }
  } 

  @action 
  Future fetchGroupsSelf() async {
    try {
      GroupsModel g = await FeedService.shared.fetchGroupsSelf();
      g3 = g;
      if(g3.body.isNotEmpty) {
        g3List.clear();
        g3List.addAll(ObservableList.of(g.body));
        groupsSelfStatus = GroupsSelfStatus.loaded;
      } else {
        groupsSelfStatus = GroupsSelfStatus.empty;
      }
    } on ServerErrorException catch(_) {
      groupsSelfStatus = GroupsSelfStatus.error;
    } catch(e) {
      print(e);
    }
  } 

  @action
  Future fetchGroupsMostRecentLoad([String cursorId = ""]) async {
    GroupsModel g = await FeedService.shared.fetchGroupsMostRecent(cursorId);
    g1 = g;
    g1List.addAll(ObservableList.of(g.body));     
    groupsMostRecentStatus = GroupsMostRecentStatus.loaded;
  }

  @action
  Future fetchGroupsMostPopularLoad([String cursorId = ""]) async {
    GroupsModel g = await FeedService.shared.fetchGroupsMostPopular(cursorId);
    g2 = g;
    g2List.addAll(ObservableList.of(g.body));     
    groupsMostPopularStatus = GroupsMostPopularStatus.loaded;
  }

  @action
  Future fetchGroupsSelfLoad([String cursorId = ""]) async {
    GroupsModel g = await FeedService.shared.fetchGroupsSelf(cursorId);
    g3 = g;
    g3List.addAll(ObservableList.of(g.body));     
    groupsSelfStatus = GroupsSelfStatus.loaded;
  }

  @action 
  Future fetchGroupsMetaDataList() async {
    GroupsMetaData g = await FeedService.shared.fetchGroupsMetaData();
    groupsMetaData = g;
    if(g.body.isNotEmpty) {
      groupsMetaDataList.clear();
      groupsMetaDataList.addAll(ObservableList.of(g.body));
      groupsMetaDataStatus = GroupsMetaDataStatus.loaded;
    } else {
      groupsMetaDataStatus = GroupsMetaDataStatus.empty;
    }
  }

  @action
  Future fetchGroupsMetaDataListLoad([String cursorId = ""]) async {
    GroupsMetaData g = await FeedService.shared.fetchGroupsMetaData(cursorId);
    groupsMetaData = g;
    groupsMetaDataList.clear();
    groupsMetaDataList.addAll(ObservableList.of(g.body));     
    groupsSelfStatus = GroupsSelfStatus.loaded;
  }

  @action
  Future addGroup(String desc, String name, [File fileProfile, File fileBackground]) async {
    await FeedService.shared.addGroup(desc, name, fileProfile, fileBackground);
    Future.delayed(Duration.zero, () {
      fetchGroupsMetaDataList();
    });
  }

  @action
  Future updateGroup(String groupId, String desc, String name, [File fileProfile, File fileBack]) async {
    await FeedService.shared.updateGroup(groupId, desc, name, fileProfile, fileBack);
    Future.delayed(Duration.zero, () {
      fetchGroupsMetaDataList();
    });
    Future.delayed(Duration.zero, () {
      fetchGroup(groupId);
    });
  }

  @action
  addComment(data) {
    if(data["payload"]["reference"]["classId"] == "stickercontent") {
      c1List.insert(0,
        CommentBody(
          classId: data["payload"]["classId"],
          id: data["payload"]["id"],
          user: CommentUser(
            id: data["payload"]["refUser"]["id"],
            classId: data["payload"]["refUser"]["classId"],
            level: data["payload"]["refUser"]["level"],
            nickname: data["payload"]["refUser"]["nickname"],
            timezone: data["payload"]["refUser"]["timezone"],
            profilePic: FeedMedia(
              originalName: data["payload"]["image"]["originalName"],
              fileLength: data["payload"]["image"]["fileLength"],
              contentType: data["payload"]["image"]["contentType"],
              kind: PostType.IMAGE,
              path: data["payload"]["image"]["path"]
            ),
          ),
          content: CommentContent(
            url: data["payload"]["reference"]["url"]
          ),
          liked: [],
          type: "STICKER",
          targetId: data["payload"]["targetId"],
          targetType: data["payload"]["targetType"],
          created: DateTime.now().toString(),
          numOfLikes: 0,
          numOfReplies: 0,
        )
      );
    } else {
      c1List.insert(0,
        CommentBody(
          classId: data["payload"]["classId"],
          id: data["payload"]["id"],
          user: CommentUser(
            id: data["payload"]["refUser"]["id"],
            classId: data["payload"]["refUser"]["classId"],
            level: data["payload"]["refUser"]["level"],
            nickname: data["payload"]["refUser"]["nickname"],
            timezone: data["payload"]["refUser"]["timezone"],
            profilePic: FeedMedia(
              originalName: data["payload"]["image"]["originalName"],
              fileLength: data["payload"]["image"]["fileLength"],
              contentType: data["payload"]["image"]["contentType"],
              kind: PostType.IMAGE,
              path: data["payload"]["image"]["path"]
            ),
          ),
          content: CommentContent(
            charset: data["payload"]["reference"]["charset"],
            text: data["payload"]["reference"]["text"]
          ),
          liked: [],
          type: "TEXT",
          targetId: data["payload"]["targetId"],
          targetType: data["payload"]["targetType"],
          created: DateTime.now().toString(),
          numOfLikes: 0,
          numOfReplies: 0,
        )
      );
    }
    Future.delayed(Duration.zero, () {
      fetchListCommentMostRecent(data["payload"]["targetId"]);
      fetchPost(data["payload"]["targetId"]);
    });
    Future.delayed(Duration.zero, () {
      fetchGroupsMostRecent();
      fetchGroupsMostPopular();
      fetchGroupsSelf();
    });
  }

  @action
  Future sendPostText(String text, [String groupId = ""]) async {
    await FeedService.shared.sendPostText(text, groupId);
    if (groupId == null) {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecent();
        fetchGroupsMostPopular();
        fetchGroupsSelf();
      });
    } else {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecentChild(groupId);
        fetchGroupsMostPopularChild(groupId);
        fetchGroupsSelfChild(groupId);
      });
    }
  }

  @action
  Future sendPostLink(String caption, String url, [String groupId = ""]) async {
    await FeedService.shared.sendPostLink(caption, url, groupId);
    if (groupId == null) {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecent();
        fetchGroupsMostPopular();
        fetchGroupsSelf();
      });
    } else {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecentChild(groupId);
        fetchGroupsMostPopularChild(groupId);
        fetchGroupsSelfChild(groupId);
      });
    }
  }


  @action
  Future sendPostImage(String caption, List<File> files, [String groupId = ""]) async {
    await FeedService.shared.sendPostImage(caption, files, groupId);
    if (groupId == null) {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecent();
        fetchGroupsMostPopular();
        fetchGroupsSelf();
      });
    } else {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecentChild(groupId);
        fetchGroupsMostPopularChild(groupId);
        fetchGroupsSelfChild(groupId);
      });
    }
  }

  @action
  Future sendPostImageCamera(String caption, File file, [String groupId = ""]) async {
    await FeedService.shared.sendPostImageCamera(caption, file);
    if(groupId == null)  {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecent();
        fetchGroupsMostPopular();
        fetchGroupsSelf();
      });
    } else {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecentChild(groupId);
        fetchGroupsMostPopularChild(groupId);
        fetchGroupsSelfChild(groupId);
      });
    }
  }

  @action
  Future sendPostDoc(FilePickerResult files, [String groupId = ""]) async {
    await FeedService.shared.sendPostDoc(files, groupId);
    if (groupId == null) {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecent();
        fetchGroupsMostPopular();
        fetchGroupsSelf();
      });
    } else {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecentChild(groupId);
        fetchGroupsMostPopularChild(groupId);
        fetchGroupsSelfChild(groupId);
      });
    }
  }

  @action
  Future sendPostVideo(String caption, File file, [String groupId = ""]) async {
    groupsMostRecentStatus = GroupsMostRecentStatus.loaded;
    await FeedService.shared.sendPostVideo(caption, file, groupId);
    if (groupId == null) {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecent();
        fetchGroupsMostPopular();
        fetchGroupsSelf();
      });
    } else {
      Future.delayed(Duration.zero, () {
        fetchGroupsMostRecentChild(groupId);
        fetchGroupsMostPopularChild(groupId);
        fetchGroupsSelfChild(groupId);
      });
    }
  }

  @action 
  addReply(data) {
    replyList.add(
      ReplyBody(
        id: data["payload"]["id"],
        classId: data["payload"]["classId"],
        user: ReplyUser(
          id: data["payload"]["refUser"]["id"],
          classId: data["payload"]["refUser"]["classId"],
          level: data["payload"]["refUser"]["level"],
          nickname: data["payload"]["refUser"]["nickname"],
          timezone: data["payload"]["refUser"]["timezone"],
          profilePic: FeedMedia(
            originalName: data["payload"]["image"]["originalName"],
            fileLength: data["payload"]["image"]["fileLength"],
            contentType: data["payload"]["image"]["contentType"],
            kind: PostType.IMAGE,
            path: data["payload"]["image"]["path"]
          ),
        ),
        liked: [],
        targetId: data["payload"]["targetId"],
        created: DateTime.now().toString(),
        numOfLikes: 0,
        type: "TEXT",
        content: Content(
          charset: data["payload"]["reference"]["charset"],
          text: data["payload"]["reference"]["text"]
        ),
      )
    );
    int iCommentMostRecent = c1List.indexWhere((element) => element.id == data["payload"]["targetId"]);
    Future.delayed(Duration.zero, () {
      fetchAllReply(data["payload"]["targetId"]);
      fetchComment(data["payload"]["targetId"]);
      fetchListCommentMostRecent(c1List[iCommentMostRecent].targetId);
    });    
  }

  @action 
  Future like(String targetId, String targetType, [String groupId = ""]) async {
    int iMostRecent = g1List.indexWhere((element) => element.id == targetId);
    int iMostPopular = g2List.indexWhere((element) => element.id == targetId);
    int iSelf = g3List.indexWhere((element) => element.id == targetId);
    int iMostRecentC = g1ListC.indexWhere((element) => element.id == targetId);
    int iMostPopularC = g2ListC.indexWhere((element) => element.id == targetId);
    int iSelfC = g3ListC.indexWhere((element) => element.id == targetId);
    int iCommentMostRecent = c1List.indexWhere((element) => element.id == targetId);
    int iReply = replyList.indexWhere((element) => element.id == targetId);
    HttpClientResponse response = await FeedService.shared.like(targetId, targetType, "THUMB_UP");
    String responseBody = await response.transform(utf8.decoder).join();
    Map<String, dynamic> decoded = jsonDecode(responseBody);
    if(iMostRecent != -1) {
      g1List[iMostRecent].numOfLikes = decoded["body"]["targetNumOfLikes"]; 
      if(decoded["body"]["type"] == "THUMB_UP") {
        g1List[iMostRecent].liked.add(
          FeedLiked(
            targetType: targetType,
            targetId: targetId,
            type: "THUMB_UP"
          )
        );
      } else {
        g1List[iMostRecent].liked.clear();
      }
      groupsMostRecentStatus = GroupsMostRecentStatus.loaded;
    }
    if(iMostPopular != -1) {
      g2List[iMostPopular].numOfLikes = decoded["body"]["targetNumOfLikes"]; 
      if(decoded["body"]["type"] == "THUMB_UP") {
        g2List[iMostPopular].liked.add(
          FeedLiked(
            targetType: targetType,
            targetId: targetId,
            type: "THUMB_UP"
          )
        );
      } else {
        g2List[iMostPopular].liked.clear();
      }
      groupsMostPopularStatus = GroupsMostPopularStatus.loaded;
    }
    if(iSelf != -1) {
      g3List[iSelf].numOfLikes = decoded["body"]["targetNumOfLikes"]; 
      if(decoded["body"]["type"] == "THUMB_UP") {
        g3List[iSelf].liked.add(
          FeedLiked(
            targetType: targetType,
            targetId: targetId,
            type: "THUMB_UP"
          )
        );
      } else {
        g3List[iSelf].liked.clear();
      }
      groupsSelfStatus = GroupsSelfStatus.loaded;
    }

    if(targetType == "POST") {
      if(post?.body != null) {
        post.body.numOfLikes = decoded["body"]["targetNumOfLikes"]; 
        if(decoded["body"]["type"] == "THUMB_UP") {
          post.body.liked.add(
            FeedLiked(
              targetType: targetType,
              targetId: targetId,
              type: "THUMB_UP"
            )
          );
        } else {
          post.body.liked.clear();
        }
        postStatus = PostStatus.loaded;
      }
    }

    if(targetType == "COMMENT") {
      if(singleComment?.body != null) {
        singleComment.body.numOfLikes = decoded["body"]["targetNumOfLikes"]; 
        if(decoded["body"]["type"] == "THUMB_UP") {
          singleComment.body.liked.add(
            FeedLiked(
              targetType: targetType,
              targetId: targetId,
              type: "THUMB_UP"
            )
          );
        } else {
          singleComment.body.liked.clear();
        }
        singleCommentStatus = SingleCommentStatus.loaded;
      }
    }

    if(targetType == "REPLY") {
      if(singleReply?.body != null) {
        singleReply.body.numOfLikes = decoded["body"]["targetNumOfLikes"]; 
        if(decoded["body"]["type"] == "THUMB_UP") {
          singleReply.body.liked.add(
            FeedLiked(
              targetType: targetType,
              targetId: targetId,
              type: "THUMB_UP"
            )
          );
        } else {
          singleReply.body.liked.clear();
        }
        singleReplyStatus = SingleReplyStatus.loaded;
      }
    }
   
    if(iCommentMostRecent != -1) {
      c1List[iCommentMostRecent].numOfLikes = decoded["body"]["targetNumOfLikes"]; 
      if(decoded["body"]["type"] == "THUMB_UP") {
        c1List[iCommentMostRecent].liked.add(
          FeedLiked(
            targetType: targetType,
            targetId: targetId,
            type: "THUMB_UP"
          )
        );
      } else {
        c1List[iCommentMostRecent].liked.clear();
      }
      commentMostRecentStatus = CommentMostRecentStatus.loaded;
    }

    if(iMostRecentC != -1) {
      g1ListC[iMostRecentC].numOfLikes = decoded["body"]["targetNumOfLikes"];
      if(decoded["body"]["type"] == "THUMB_UP") {
        g1ListC[iMostRecentC].liked.add(
          FeedLiked(
            targetId: targetId,
            targetType: targetType,
            type: "THUMB_UP",
          )
        );
      } else {
        g1ListC[iMostRecentC].liked.clear();
      }
      groupsMostRecentStatusC = GroupsMostRecentStatusC.loaded;
    }  

    if(iMostPopularC != -1) {
      g2ListC[iMostPopularC].numOfLikes = decoded["body"]["targetNumOfLikes"];
      if(decoded["body"]["type"] == "THUMB_UP") {
        g2ListC[iMostPopularC].liked.add(
          FeedLiked(
            targetId: targetId,
            targetType: targetType,
            type: "THUMB_UP",
          )
        );
      } else {
        g2ListC[iMostPopularC].liked.clear();
      }
      groupsMostPopularStatusC = GroupsMostPopularStatusC.loaded;
    }  

    if(iSelfC != -1) {
      g3ListC[iSelfC].numOfLikes = decoded["body"]["targetNumOfLikes"];
      if(decoded["body"]["type"] == "THUMB_UP") {
        g3ListC[iSelfC].liked.add(
          FeedLiked(
            targetId: targetId,
            targetType: targetType,
            type: "THUMB_UP",
          )
        );
      } else {
        g3ListC[iSelfC].liked.clear();
      }
      groupsSelfStatusC = GroupsSelfStatusC.loaded;
    }  

    if(iReply != -1) {
      replyList[iReply].numOfLikes = decoded["body"]["targetNumOfLikes"]; 
      if(decoded["body"]["type"] == "THUMB_UP") {
        replyList[iReply].liked.add(
          FeedLiked(
            targetType: targetType,
            targetId: targetId,
            type: "THUMB_UP"
          )
        );
      } else {
        replyList[iReply].liked.clear();
      }
      replyStatus = ReplyStatus.loaded;
    }
  }

}