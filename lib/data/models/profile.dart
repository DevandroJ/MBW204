class ProfileModel {
  ProfileModel({
    this.profileData,
    this.code,
    this.message,
  });

  List<ProfileData> profileData;
  int code;
  String message;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    profileData: List<ProfileData>.from(json["body"].map((x) => ProfileData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );
}

class ProfileData {
  ProfileData({
    this.id,
    this.userId,
    this.address,
    this.fullname,
    this.gender,
    this.shortBio,
    this.profilePic,
    this.status,
    this.idMember,
    this.chapter,
    this.subModel,
    this.bodyStyle,
    this.noKtp,
    this.companyName,
    this.referralCode,
    this.referralBy,
    this.created,
    this.updated,
  });

  int id;
  String userId;
  String address;
  String fullname;
  String gender;
  String shortBio;
  String profilePic;
  bool status;
  String idMember;
  String chapter;
  String subModel;
  String bodyStyle;
  String noKtp;
  String companyName;
  String referralCode;
  String referralBy;
  DateTime created;
  DateTime updated;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    userId: json["user_id"],
    address: json["address"],
    fullname: json["fullname"],
    gender: json["gender"],
    shortBio: json["short_bio"],
    profilePic: json["profile_pic"],
    status: json["status"],
    idMember: json["id_member"],
    chapter: json["chapter"],
    subModel: json["sub_modal"],
    bodyStyle: json["body_style"],
    noKtp: json["no_ktp"],
    companyName: json["company_name"],
    referralCode: json["referral_code"],
    referralBy: json["referral_by"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
  );
}
