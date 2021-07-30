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
    this.updated,
    this.identity,
    this.userId,
    this.displayName,
    this.profilePic,
    this.group,
    this.classId,
  });

  String id;
  String updated;
  String identity;
  String userId;
  String displayName;
  ProfilePic profilePic;
  bool group;
  String classId;

  factory ListChatData.fromJson(Map<String, dynamic> json) => ListChatData(
    id: json["id"] == null ? null : json["id"],
    updated: json["updated"] == null ? null : json["updated"],
    identity: json["identity"] == null ? null : json["identity"],
    userId: json["userId"] == null ? null : json["userId"],
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
