class InquiryPLNPascabayarModel {
  InquiryPLNPascabayarModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  InquiryPLNPascaBayarData body;
  dynamic error;

  factory InquiryPLNPascabayarModel.fromJson(Map<String, dynamic> json) => InquiryPLNPascabayarModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : InquiryPLNPascaBayarData.fromJson(json["body"]),
    error: json["error"],
  );
}

class InquiryPLNPascaBayarData {
  InquiryPLNPascaBayarData({
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
  String transactionRef;
  InquiryPLNPascaBayarUserData data;
  String classId;

  factory InquiryPLNPascaBayarData.fromJson(Map<String, dynamic> json) => InquiryPLNPascaBayarData(
    inquiryStatus: json["inquiryStatus"] == null ? null : json["inquiryStatus"],
    productPrice: json["productPrice"] == null ? null : json["productPrice"],
    productId: json["productId"] == null ? null : json["productId"],
    productCode: json["productCode"] == null ? null : json["productCode"],
    productName: json["productName"] == null ? null : json["productName"],
    accountNumber1: json["accountNumber1"] == null ? null : json["accountNumber1"],
    accountNumber2: json["accountNumber2"] == null ? null : json["accountNumber2"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    transactionRef: json["transactionRef"] == null ? null : json["transactionRef"],
    data: json["data"] == null ? null : InquiryPLNPascaBayarUserData.fromJson(json["data"]),
    classId: json["classId"] == null ? null : json["classId"],
  );

}

class InquiryPLNPascaBayarUserData {
  InquiryPLNPascaBayarUserData({
    this.amount,
    this.accountName,
    this.admin,
  });

  double amount;
  String accountName;
  double admin;

  factory InquiryPLNPascaBayarUserData.fromJson(Map<String, dynamic> json) => InquiryPLNPascaBayarUserData(
    amount: json["amount"] == null ? null : json["amount"],
    accountName: json["accountName"] == null ? null : json["accountName"],
    admin: json["admin"] == null ? null : json["admin"],
  );
}
