import './feedenumvalues.dart';
import './feedtimezone.dart';
import './feedmedia.dart';

class Notification {
  Notification({
    this.code,
    this.message,
    this.nextCursor,
    this.count,
    this.hasNext,
    this.first,
    this.body,
  });

  int code;
  String message;
  String nextCursor;
  int count;
  bool hasNext;
  bool first;
  List<NotificationBody> body;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    code: json["code"],
    message: json["message"],
    nextCursor: json["nextCursor"],
    count: json["count"],
    hasNext: json["hasNext"],
    first: json["first"],
    body: List<NotificationBody>.from(json["body"].map((x) => NotificationBody.fromJson(x))),
  );
}

class NotificationBody {
  NotificationBody({
    this.id,
    this.refUser,
    this.userId,
    this.message,
    this.activity,
    this.targetId,
    this.targetType,
    this.image,
    this.classId,
    this.created
  });

  String id;
  NotificationRefUser refUser;
  UserId userId;
  String message;
  Activity activity;
  String targetId;
  TargetType targetType;
  NotificationImage image;
  BodyClassId classId;
  String created;

  factory NotificationBody.fromJson(Map<String, dynamic> json) => NotificationBody(
    id: json["id"],
    refUser: NotificationRefUser.fromJson(json["refUser"]),
    userId: userIdValues.map[json["userId"]],
    message: json["message"],
    activity: activityValues.map[json["activity"]],
    targetId: json["targetId"],
    targetType: targetTypeValues.map[json["targetType"]],
    image: NotificationImage.fromJson(json["image"]),
    classId: bodyClassIdValues.map[json["classId"]],
    created: json["created"]
  );
}

enum Activity { COMMENT, LIKE, REPLY }

final activityValues = EnumValues({
  "COMMENT": Activity.COMMENT,
  "LIKE": Activity.LIKE,
  "REPLY": Activity.REPLY
});

enum BodyClassId { ONOTIFICATION }

final bodyClassIdValues = EnumValues({
  "onotification": BodyClassId.ONOTIFICATION
});

class NotificationImage {
  NotificationImage({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
    this.kind,
  });

  OriginalName originalName;
  int fileLength;
  Path path;
  ContentType contentType;
  Kind kind;

  factory NotificationImage.fromJson(Map<String, dynamic> json) => NotificationImage(
    originalName: originalNameValues.map[json["originalName"]],
    fileLength: json["fileLength"],
    path: pathValues.map[json["path"]],
    contentType: contentTypeValues.map[json["contentType"]],
    kind: kindValues.map[json["kind"]],
  );
}

enum ContentType { IMAGE_PNG }

final contentTypeValues = EnumValues({
  "image/png": ContentType.IMAGE_PNG
});

enum Kind { IMAGE }

final kindValues = EnumValues({
  "IMAGE": Kind.IMAGE
});

enum OriginalName { PROFILE_PIC_PNG }

final originalNameValues = EnumValues({
  "profile-pic.png": OriginalName.PROFILE_PIC_PNG
});

enum Path { COMMUNITY_SAMPLE_PROFILE_PIC_PNG }

final pathValues = EnumValues({
  "/community/sample/profile-pic.png": Path.COMMUNITY_SAMPLE_PROFILE_PIC_PNG
});

class NotificationRefUser {
  NotificationRefUser({
    this.id,
    this.timezone,
    this.nickname,
    this.profilePic,
    this.level,
    this.classId,
  });

  UserId id;
  Timezone timezone;
  Nickname nickname;
  FeedMedia profilePic;
  Level level;
  RefUserClassId classId;

  factory NotificationRefUser.fromJson(Map<String, dynamic> json) => NotificationRefUser(
    id: userIdValues.map[json["id"]],
    timezone: timezoneValues.map[json["timezone"]],
    nickname: nicknameValues.map[json["nickname"]],
    profilePic: FeedMedia.fromJson(json["profilePic"]),
    level: levelValues.map[json["level"]],
    classId: refUserClassIdValues.map[json["classId"]],
  );
}

enum RefUserClassId { OUSER }

final refUserClassIdValues = EnumValues({
  "ouser": RefUserClassId.OUSER
});

enum UserId { USER001, USER002 }

final userIdValues = EnumValues({
  "user001": UserId.USER001,
  "user002": UserId.USER002
});

enum Level { TOP_LEADER, LEADER }

final levelValues = EnumValues({
  "LEADER": Level.LEADER,
  "TOP_LEADER": Level.TOP_LEADER
});

enum Nickname { USER_1, USER_2 }

final nicknameValues = EnumValues({
  "User 1": Nickname.USER_1,
  "User 2": Nickname.USER_2
});

enum TargetType { POST, COMMENT, REPLY }

final targetTypeValues = EnumValues({
  "COMMENT": TargetType.COMMENT,
  "POST": TargetType.POST,
  "REPLY": TargetType.REPLY
});