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
    this.noKtp,
    this.idCardNumber,
    this.idMember,
    this.noHp,
    this.shortBio,
    this.profilePic,
    this.status,
    this.noAnggota,
    this.golonganDarah,
    this.disabilitas,
    this.created,
    this.updated,
  });

  int id;
  String userId;
  String address;
  String fullname;
  String gender;
  String noKtp;
  String idCardNumber;
  String idMember;
  String noHp;
  String shortBio;
  String profilePic;
  bool status;
  String noAnggota;
  String golonganDarah;
  String disabilitas;
  DateTime created;
  DateTime updated;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    userId: json["user_id"],
    address: json["address"],
    fullname: json["fullname"],
    gender: json["gender"],
    noKtp: json["noKtp"],
    idCardNumber: json["id_card_number"],
    idMember: json["id_member"],
    noHp: json["noHp"],
    shortBio: json["short_bio"],
    profilePic: json["profile_pic"],
    status: json["status"],
    noAnggota: json["no_anggota"],
    golonganDarah: json["golongan_darah"],
    disabilitas: json["disabilitas"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
  );
}
