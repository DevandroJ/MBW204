class InquiryTopUpModel {
  InquiryTopUpModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  InquiryTopUpData body;
  dynamic error;

  factory InquiryTopUpModel.fromJson(Map<String, dynamic> json) => InquiryTopUpModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : InquiryTopUpData.fromJson(json["body"]),
    error: json["error"],
  );
}

class InquiryTopUpData {
  InquiryTopUpData({
    this.inquiryStatus,
    this.productPrice,
    this.productId,
    this.productCode,
    this.productName,
    this.accountNumber1,
    this.accountNumber2,
    this.transactionId,
    this.transactionRef,
    this.data,
    this.classId,
  });

  String inquiryStatus;
  double productPrice;
  String productId;
  String productCode;
  String productName;
  String accountNumber1;
  String accountNumber2;
  String transactionId;
  dynamic transactionRef;
  InquiryTopUpUserData data;
  String classId;

  factory InquiryTopUpData.fromJson(Map<String, dynamic> json) => InquiryTopUpData(
    inquiryStatus: json["inquiryStatus"] == null ? null : json["inquiryStatus"],
    productPrice: json["productPrice"] == null ? null : json["productPrice"],
    productId: json["productId"] == null ? null : json["productId"],
    productCode: json["productCode"] == null ? null : json["productCode"],
    productName: json["productName"] == null ? null : json["productName"],
    accountNumber1: json["accountNumber1"] == null ? null : json["accountNumber1"],
    accountNumber2: json["accountNumber2"] == null ? null : json["accountNumber2"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    transactionRef: json["transactionRef"],
    data: json["data"] == null ? null : InquiryTopUpUserData.fromJson(json["data"]),
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class InquiryTopUpUserData {
  InquiryTopUpUserData({
    this.balance,
    this.topupAmount,
    this.accountName,
    this.admin,
  });

  double balance;
  double topupAmount;
  String accountName;
  double admin;

  factory InquiryTopUpUserData.fromJson(Map<String, dynamic> json) => InquiryTopUpUserData(
    balance: json["balance"] == null ? null : json["balance"],
    topupAmount: json["topupAmount"] == null ? null : json["topupAmount"],
    accountName: json["accountName"] == null ? null : json["accountName"],
    admin: json["admin"] == null ? null : json["admin"],
  );
}
