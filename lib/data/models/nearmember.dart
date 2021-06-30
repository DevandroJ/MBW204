class NearMemberModel {
  NearMemberModel({
    this.body,
    this.code,
    this.message,
  });

  List<NearMemberData> body;
  int code;
  String message;

  factory NearMemberModel.fromJson(Map<String, dynamic> json) => NearMemberModel(
    body: json["body"] == null ? null : List<NearMemberData>.from(json["body"].map((x) => NearMemberData.fromJson(x))),
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
  );
}

class NearMemberData {
  NearMemberData({
    this.distance,
    this.address,
    this.avatarUrl,
    this.fullname,
    this.lastseenDay,
    this.lastseenHour,
    this.lastseenMinute,
    this.phoneNumber,
    this.userId,
  });

  String distance;
  String address;
  String avatarUrl;
  String fullname;
  String lastseenDay;
  String lastseenHour;
  String lastseenMinute;
  String phoneNumber;
  String userId;

  factory NearMemberData.fromJson(Map<String, dynamic> json) => NearMemberData(
    distance: json["distance"],
    address: json["address"],
    avatarUrl: json["avatar_url"],
    fullname: json["fullname"],
    lastseenDay: json["lastseen_day"],
    lastseenHour: json["lastseen_hour"],
    lastseenMinute: json["lastseen_minute"],
    phoneNumber: json["phone_number"],
    userId: json["user_id"],
  );
}
