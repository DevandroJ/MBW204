class InquiryRegisterModel {
  InquiryRegisterModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  InquiryRegisterData body;
  dynamic error;

  factory InquiryRegisterModel.fromJson(Map<String, dynamic> json) => InquiryRegisterModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : InquiryRegisterData.fromJson(json["body"]),
    error: json["error"],
  );

}

class InquiryRegisterData {
  InquiryRegisterData({
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
  InquiryRegisterUserData data;
  String classId;

  factory InquiryRegisterData.fromJson(Map<String, dynamic> json) => InquiryRegisterData(
    inquiryStatus: json["inquiryStatus"] == null ? null : json["inquiryStatus"],
    productPrice: json["productPrice"] == null ? null : json["productPrice"],
    productId: json["productId"] == null ? null : json["productId"],
    productCode: json["productCode"] == null ? null : json["productCode"],
    productName: json["productName"] == null ? null : json["productName"],
    accountNumber1: json["accountNumber1"] == null ? null : json["accountNumber1"],
    accountNumber2: json["accountNumber2"] == null ? null : json["accountNumber2"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    transactionRef: json["transactionRef"] == null ? null : json["transactionRef"],
    data: json["data"] == null ? null : InquiryRegisterUserData.fromJson(json["data"]),
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class InquiryRegisterUserData {
  InquiryRegisterUserData({
    this.billAmount,
    this.phoneNumber,
    this.accountName,
    this.admin,
  });

  double billAmount;
  String phoneNumber;
  String accountName;
  double admin;

  factory InquiryRegisterUserData.fromJson(Map<String, dynamic> json) => InquiryRegisterUserData(
    billAmount: json["billAmount"] == null ? null : json["billAmount"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    accountName: json["accountName"] == null ? null : json["accountName"],
    admin: json["admin"] == null ? null : json["admin"],
  );
}




class PayInquiryRegisterModel {
  PayInquiryRegisterModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  PayInquiryRegisterData body;
  dynamic error;

  factory PayInquiryRegisterModel.fromJson(Map<String, dynamic> json) => PayInquiryRegisterModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : PayInquiryRegisterData.fromJson(json["body"]),
    error: json["error"],
  );
}

class PayInquiryRegisterData {
  PayInquiryRegisterData({
    this.purchaseStatus,
    this.paymentStatus,
    this.productPrice,
    this.productId,
    this.productCode,
    this.accountNumber1,
    this.accountNumber2,
    this.description,
    this.transactionId,
    this.transactionRef,
    this.paymentRef,
    this.data,
    this.classId,
  });

  String purchaseStatus;
  String paymentStatus;
  double productPrice;
  String productId;
  String productCode;
  String accountNumber1;
  String accountNumber2;
  String description;
  String transactionId;
  String transactionRef;
  String paymentRef;
  PayInquiryRegisterUserData data;
  String classId;

  factory PayInquiryRegisterData.fromJson(Map<String, dynamic> json) => PayInquiryRegisterData(
    purchaseStatus: json["purchaseStatus"] == null ? null : json["purchaseStatus"],
    paymentStatus: json["paymentStatus"] == null ? null : json["paymentStatus"],
    productPrice: json["productPrice"] == null ? null : json["productPrice"],
    productId: json["productId"] == null ? null : json["productId"],
    productCode: json["productCode"] == null ? null : json["productCode"],
    accountNumber1: json["accountNumber1"] == null ? null : json["accountNumber1"],
    accountNumber2: json["accountNumber2"] == null ? null : json["accountNumber2"],
    description: json["description"] == null ? null : json["description"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    transactionRef: json["transactionRef"] == null ? null : json["transactionRef"],
    paymentRef: json["paymentRef"] == null ? null : json["paymentRef"],
    data: json["data"] == null ? null : PayInquiryRegisterUserData.fromJson(json["data"]),
    classId: json["classId"] == null ? null : json["classId"],
  );

}

class PayInquiryRegisterUserData {
  PayInquiryRegisterUserData({
    this.paymentGuide,
    this.paymentChannel,
    this.paymentRefId,
    this.paymentAdminFee,
    this.paymentCode,
  });

  String paymentGuide;
  String paymentChannel;
  String paymentRefId;
  String paymentAdminFee;
  String paymentCode;

  factory PayInquiryRegisterUserData.fromJson(Map<String, dynamic> json) => PayInquiryRegisterUserData(
    paymentGuide: json["payment_guide"] == null ? null : json["payment_guide"],
    paymentChannel: json["payment_channel"] == null ? null : json["payment_channel"],
    paymentRefId: json["payment_ref_id"] == null ? null : json["payment_ref_id"],
    paymentAdminFee: json["payment_admin_fee"] == null ? null : json["payment_admin_fee"],
    paymentCode: json["payment_code"] == null ? null : json["payment_code"],
  );
}
