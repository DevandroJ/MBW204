class ListConversationModel {
  ListConversationModel({
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
  List<ListConversationData> data;

  factory ListConversationModel.fromJson(Map<String, dynamic> json) => ListConversationModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    hasNext: json["hasNext"] == null ? null : json["hasNext"],
    first: json["first"] == null ? null : json["first"],
    data: json["body"] == null ? null : List<ListConversationData>.from(json["body"].map((x) => ListConversationData.fromJson(x))),
  );
}

class ListConversationData {
  ListConversationData({
    this.id,
    this.remote,
    this.messageStatus,
    this.fromMe,
    this.contextId,
    this.type,
    this.group,
    this.content,
    this.replyToConversationId,
    this.classId,
  });

  String id;
  Remote remote;
  String messageStatus;
  bool fromMe;
  String contextId;
  String type;
  bool group;
  Content content;
  dynamic replyToConversationId;
  String classId;

  factory ListConversationData.fromJson(Map<String, dynamic> json) => ListConversationData(
    id: json["id"] == null ? null : json["id"],
    remote: json["remote"] == null ? null : Remote.fromJson(json["remote"]),
    messageStatus: json["messageStatus"] == null ? null : json["messageStatus"],
    fromMe: json["fromMe"] == null ? null : json["fromMe"],
    contextId: json["contextId"] == null ? null : json["contextId"],
    type: json["type"] == null ? null : json["type"],
    group: json["group"] == null ? null : json["group"],
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
    replyToConversationId: json["replyToConversationId"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class Content {
  Content({
    this.charset,
    this.text,
  });

  String charset;
  String text;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    charset: json["charset"] == null ? null : json["charset"],
    text: json["text"] == null ? null : json["text"],
  );
}

class Remote {
  Remote({
    this.identity,
    this.userId,
    this.group,
    this.profilePic,
    this.displayName,
    this.classId,
  });

  String identity;
  String userId;
  bool group;
  ListConversationProfilePic profilePic;
  String displayName;
  String classId;

  factory Remote.fromJson(Map<String, dynamic> json) => Remote(
    identity: json["identity"] == null ? null : json["identity"],
    userId: json["userId"] == null ? null : json["userId"],
    group: json["group"] == null ? null : json["group"],
    profilePic: json["profilePic"] == null ? null : ListConversationProfilePic.fromJson(json["profilePic"]),
    displayName: json["displayName"] == null ? null : json["displayName"],
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class ListConversationProfilePic {
  ListConversationProfilePic({
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

  factory ListConversationProfilePic.fromJson(Map<String, dynamic> json) => ListConversationProfilePic(
    originalName: json["originalName"] == null ? null : json["originalName"],
    fileLength: json["fileLength"] == null ? null : json["fileLength"],
    path: json["path"] == null ? null : json["path"],
    contentType: json["contentType"] == null ? null : json["contentType"],
    kind: json["kind"] == null ? null : json["kind"],
  );
}

