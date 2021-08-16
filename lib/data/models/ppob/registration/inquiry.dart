class InquiryRegistrationModel {
  InquiryRegistrationModel({
    this.code,
    this.message,
    this.data,
    this.error,
  });

  int code;
  String message;
  InquiryRegistrationData data;
  dynamic error;

  factory InquiryRegistrationModel.fromJson(Map<String, dynamic> json) => InquiryRegistrationModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["body"] == null ? null : InquiryRegistrationData.fromJson(json["body"]),
    error: json["error"],
  );
}

class InquiryRegistrationData {
  InquiryRegistrationData({
    this.inquiryStatus,
    this.productPrice,
    this.productId,
    this.productCode,
    this.productName,
    this.accountNumber1,
    this.accountNumber2,
    this.transactionId,
    this.transactionRef,
    this.user,
    this.classId,
  });

  String inquiryStatus;
  var productPrice;
  String productId;
  String productCode;
  String productName;
  String accountNumber1;
  String accountNumber2;
  String transactionId;
  String transactionRef;
  InquiryRegistrationUser user;
  String classId;

  factory InquiryRegistrationData.fromJson(Map<String, dynamic> json) => InquiryRegistrationData(
    inquiryStatus: json["inquiryStatus"] == null ? null : json["inquiryStatus"],
    productPrice: json["productPrice"] == null ? null : json["productPrice"],
    productId: json["productId"] == null ? null : json["productId"],
    productCode: json["productCode"] == null ? null : json["productCode"],
    productName: json["productName"] == null ? null : json["productName"],
    accountNumber1: json["accountNumber1"] == null ? null : json["accountNumber1"],
    accountNumber2: json["accountNumber2"] == null ? null : json["accountNumber2"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    transactionRef: json["transactionRef"] == null ? null : json["transactionRef"],
    user: json["data"] == null ? null : InquiryRegistrationUser.fromJson(json["data"]),
    classId: json["classId"] == null ? null : json["classId"],
  );

}

class InquiryRegistrationUser {
  InquiryRegistrationUser({
    this.amount,
    this.phoneNumber,
    this.accountName,
    this.admin,
  });

  var amount;
  String phoneNumber;
  String accountName;
  var admin;

  factory InquiryRegistrationUser.fromJson(Map<String, dynamic> json) => InquiryRegistrationUser(
    amount: json["amount"] == null ? null : json["amount"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    accountName: json["accountName"] == null ? null : json["accountName"],
    admin: json["admin"] == null ? null : json["admin"],
  );
}
