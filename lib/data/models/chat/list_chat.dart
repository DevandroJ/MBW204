class ListChatModel {
  ListChatModel({
    this.code,
    this.message,
    this.count,
    this.hasNext,
    this.first,
    this.data,
  });

  int code;
  String message;
  int count;
  bool hasNext;
  bool first;
  List<ListChatData> data;

  factory ListChatModel.fromJson(Map<String, dynamic> json) => ListChatModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    hasNext: json["hasNext"] == null ? null : json["hasNext"],
    first: json["first"] == null ? null : json["first"],
    data: json["body"] == null ? null : List<ListChatData>.from(json["body"].map((x) => ListChatData.fromJson(x))),
  );
}

class ListChatData {
  ListChatData({
    this.id,
    this.identity,
    this.userId,
    this.displayName,
    this.profilePic,
    this.group,
    this.updated,
    this.unread,
    this.contextId,
    this.latestConversation,
    this.classId,
  });

  String id;
  String identity;
  String userId;
  String displayName;
  ProfilePic profilePic;
  bool group;
  String updated;
  int unread;
  String contextId;
  LatestConversation latestConversation;
  String classId;

  factory ListChatData.fromJson(Map<String, dynamic> json) => ListChatData(
    id: json["id"] == null ? null : json["id"],
    identity: json["identity"] == null ? null : json["identity"],
    userId: json["userId"] == null ? null : json["userId"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    profilePic: json["profilePic"] == null ? null : ProfilePic.fromJson(json["profilePic"]),
    group: json["group"] == null ? null : json["group"],
    updated: json["updated"] == null ? null : json["updated"],
    unread: json["unread"] == null ? null : json["unread"],
    contextId: json["contextId"] == null ? null : json["contextId"],
    latestConversation: json["latestConversation"] == null ? null : LatestConversation.fromJson(json["latestConversation"]),
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class LatestConversation {
  LatestConversation({
    this.conversationId,
    this.messageStatus,
    this.type,
    this.content,
    this.origin,
    this.fromMe,
  });

  String conversationId;
  String messageStatus;
  String type;
  LatestConversationContent content;
  LatestConversationOrigin origin;
  bool fromMe;

  factory LatestConversation.fromJson(Map<String, dynamic> json) => LatestConversation(
    conversationId: json["conversationId"] == null ? null : json["conversationId"],
    messageStatus: json["messageStatus"] == null ? null : json["messageStatus"],
    type: json["type"] == null ? null : json["type"],
    content: json["content"] == null ? null : LatestConversationContent.fromJson(json["content"]),
    origin: json["origin"] == null ? null : LatestConversationOrigin.fromJson(json["origin"]),
    fromMe: json["fromMe"] == null ? null : json["fromMe"],
  );
}

class LatestConversationContent {
  LatestConversationContent({
    this.charset,
    this.text,
  });

  String charset;
  String text;

  factory LatestConversationContent.fromJson(Map<String, dynamic> json) => LatestConversationContent(
    charset: json["charset"] == null ? null : json["charset"],
    text: json["text"] == null ? null : json["text"],
  );
}

class LatestConversationOrigin {
  LatestConversationOrigin({
    this.userId,
    this.identity,
    this.displayName,
    this.profilePic,
    this.group,
    this.classId,
  });

  String userId;
  String identity;
  String displayName;
  ProfilePic profilePic;
  bool group;
  String classId;

  factory LatestConversationOrigin.fromJson(Map<String, dynamic> json) => LatestConversationOrigin(
    userId: json["userId"] == null ? null : json["userId"],
    identity: json["identity"] == null ? null : json["identity"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    profilePic: json["profilePic"] == null ? null : ProfilePic.fromJson(json["profilePic"]),
    group: json["group"] == null ? null : json["group"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class ProfilePic {
  ProfilePic({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
    this.kind,
  });

  String originalName;
  int fileLength;
  String path;
  String contentType;
  String kind;

  factory ProfilePic.fromJson(Map<String, dynamic> json) => ProfilePic(
    originalName: json["originalName"] == null ? null : json["originalName"],
    fileLength: json["fileLength"] == null ? null : json["fileLength"],
    path: json["path"] == null ? null : json["path"],
    contentType: json["contentType"] == null ? null : json["contentType"],
    kind: json["kind"] == null ? null : json["kind"],
  );
}
