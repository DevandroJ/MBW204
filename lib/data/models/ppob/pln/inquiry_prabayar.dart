class InquiryPLNPrabayarModel {
  InquiryPLNPrabayarModel({
    this.code,
    this.message,
    this.data,
    this.error,
  });

  int code;
  String message;
  InquiryPLNPrabayarData data;
  dynamic error;

  factory InquiryPLNPrabayarModel.fromJson(Map<String, dynamic> json) => InquiryPLNPrabayarModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["body"] == null ? null : InquiryPLNPrabayarData.fromJson(json["body"]),
    error: json["error"],
  );

   
}

class InquiryPLNPrabayarData {
  InquiryPLNPrabayarData({
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
  InquiryPLNPrabayarUser data;
  String classId;

  factory InquiryPLNPrabayarData.fromJson(Map<String, dynamic> json) => InquiryPLNPrabayarData(
    inquiryStatus: json["inquiryStatus"] == null ? null : json["inquiryStatus"],
    productPrice: json["productPrice"] == null ? null : json["productPrice"],
    productId: json["productId"] == null ? null : json["productId"],
    productCode: json["productCode"] == null ? null : json["productCode"],
    productName: json["productName"] == null ? null : json["productName"],
    accountNumber1: json["accountNumber1"] == null ? null : json["accountNumber1"],
    accountNumber2: json["accountNumber2"] == null ? null : json["accountNumber2"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    transactionRef: json["transactionRef"] == null ? null : json["transactionRef"],
    data: json["data"] == null ? null : InquiryPLNPrabayarUser.fromJson(json["data"]),
    classId: json["classId"] == null ? null : json["classId"],
  );

}

class InquiryPLNPrabayarUser {
  InquiryPLNPrabayarUser({
    this.accountName,
  });

  String accountName;

  factory InquiryPLNPrabayarUser.fromJson(Map<String, dynamic> json) => InquiryPLNPrabayarUser(
    accountName: json["accountName"] == null ? null : json["accountName"],
  );  
}
