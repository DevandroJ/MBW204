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
    this.status,
    this.userId,
    this.userName,
    this.userType,
  });

  DateTime created;
  bool emailActivated;
  bool phoneActivated;
  String emailAddress;
  String password;
  String passwordNew;
  String passwordConfirm;
  String address;
  String idCardNumber;
  String phoneNumber;
  String noAnggota;
  String role;
  String status;
  String userId;
  String userName;
  String userType;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    emailActivated: json["email_activated"],
    emailAddress: json["email_address"],
    phoneActivated: json["phone_activated"],
    phoneNumber: json["phone_number"],
    role: json["role"],
    status: json["status"],
    userId: json["user_id"],
    userName: json["user_name"],
    userType: json["user_type"],
    created: DateTime.parse(json["created"]),
  );
}
