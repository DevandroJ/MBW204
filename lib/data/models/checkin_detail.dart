class CheckInDetailModel {
  CheckInDetailModel({
    this.body,
    this.code,
    this.message,
    this.totalUser,
  });

  List<CheckInDetailData> body;
  int code;
  String message;
  int totalUser;

  factory CheckInDetailModel.fromJson(Map<String, dynamic> json) => CheckInDetailModel(
    body: json["body"] == null ? null : List<CheckInDetailData>.from(json["body"].map((x) => CheckInDetailData.fromJson(x))),
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    totalUser: json["total_user"] == null ? null : json["total_user"],
  );
}

class CheckInDetailData {
  CheckInDetailData({
    this.userId,
    this.fullname,
    this.profilePic
  });

  String userId;
  String fullname;
  String profilePic;

  factory CheckInDetailData.fromJson(Map<String, dynamic> json) => CheckInDetailData(
    userId: json["user_id"] == null ? null : json["user_id"],
    fullname: json["fullname"] == null ? null : json["fullname"],
    profilePic: json["profile_pic"] == null ? null : json["profile_pic"]
  );
}
