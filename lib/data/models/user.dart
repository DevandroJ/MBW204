class UserModel {
  UserModel({
    this.body,
    this.code,
    this.message,
  });

  ResultUser body;
  int code;
  String message;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    body: ResultUser.fromJson(json["body"]),
    code: json["code"],
    message: json["message"],
  );
}

class ResultUser {
  ResultUser({
    this.token,
    this.refreshToken,
    this.user,
  });

  String token;
  String refreshToken;
  UserData user;

  factory ResultUser.fromJson(Map<String, dynamic> json) => ResultUser(
    token: json["token"],
    refreshToken: json["refresh_token"],
    user: UserData.fromJson(json["user"]),
  );
}

class UserData {
  UserData({
    this.created,
    this.emailActivated,
    this.emailAddress,
    this.password,
    this.passwordNew,
    this.passwordConfirm,
    this.phoneActivated,
    this.phoneNumber,
    this.role,
    this.idCardNumber,
    this.idMember,
    this.address,
    this.companyName,
    this.status,
    this.userId,
    this.username,
    this.fullname,
    this.userType,
    this.chapter,
    this.subModel,
    this.bodyStyle,
    this.statusRegister
  });

  DateTime created;
  bool emailActivated;
  bool phoneActivated;
  String emailAddress;
  String password;
  String passwordNew;
  String passwordConfirm;
  String address;
  String companyName;
  String idCardNumber;
  String idMember;
  String phoneNumber;
  String noAnggota;
  String role;
  String status;
  String userId;
  String username;
  String fullname;
  String userType;
  String chapter;
  String subModel;
  String bodyStyle;
  String statusRegister;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    emailActivated: json["email_activated"],
    emailAddress: json["email_address"],
    phoneActivated: json["phone_activated"],
    phoneNumber: json["phone_number"],
    role: json["role"],
    status: json["status"],
    userId: json["user_id"],
    username: json["user_name"],
    userType: json["user_type"],
    created: DateTime.parse(json["created"]),
    idMember: json["id_member"],
    idCardNumber: json["id_card_number"],
    companyName: json["company_name"],
    chapter: json["chapter"],
    subModel: json["sub_model"],
    bodyStyle: json["body_style"],
    statusRegister: json["status_register"]
  );
}
