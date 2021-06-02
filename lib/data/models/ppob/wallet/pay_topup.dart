class PayTopUpModel {
  PayTopUpModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  PayTopUpData body;
  dynamic error;

  factory PayTopUpModel.fromJson(Map<String, dynamic> json) => PayTopUpModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : PayTopUpData.fromJson(json["body"]),
    error: json["error"],
  );
}

class PayTopUpData {
  PayTopUpData({
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
  dynamic transactionRef;
  String paymentRef;
  PayTopUpDataBank data;
  String classId;

  factory PayTopUpData.fromJson(Map<String, dynamic> json) => PayTopUpData(
    purchaseStatus: json["purchaseStatus"] == null ? null : json["purchaseStatus"],
    paymentStatus: json["paymentStatus"] == null ? null : json["paymentStatus"],
    productPrice: json["productPrice"] == null ? null : json["productPrice"],
    productId: json["productId"] == null ? null : json["productId"],
    productCode: json["productCode"] == null ? null : json["productCode"],
    accountNumber1: json["accountNumber1"] == null ? null : json["accountNumber1"],
    accountNumber2: json["accountNumber2"] == null ? null : json["accountNumber2"],
    description: json["description"] == null ? null : json["description"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    transactionRef: json["transactionRef"],
    paymentRef: json["paymentRef"] == null ? null : json["paymentRef"],
    data: json["data"] == null ? null : PayTopUpDataBank.fromJson(json["data"]),
    classId: json["classId"] == null ? null : json["classId"],
  );
}

class PayTopUpDataBank {
  PayTopUpDataBank({
    this.paymentGuide,
    this.paymentGuide2Url,
    this.paymentChannel,
    this.paymentRefId,
    this.paymentGuideUrl,
    this.paymentAdminFee,
    this.paymentCode,
  });

  String paymentGuide;
  String paymentGuide2Url;
  String paymentChannel;
  String paymentRefId;
  String paymentGuideUrl;
  String paymentAdminFee;
  String paymentCode;

  factory PayTopUpDataBank.fromJson(Map<String, dynamic> json) => PayTopUpDataBank(
    paymentGuide: json["payment_guide"] == null ? null : json["payment_guide"],
    paymentGuide2Url: json["payment_guide2_url"] == null ? null : json["payment_guide2_url"],
    paymentChannel: json["payment_channel"] == null ? null : json["payment_channel"],
    paymentRefId: json["payment_ref_id"] == null ? null : json["payment_ref_id"],
    paymentGuideUrl: json["payment_guide_url"] == null ? null : json["payment_guide_url"],
    paymentAdminFee: json["payment_admin_fee"] == null ? null : json["payment_admin_fee"],
    paymentCode: json["payment_code"] == null ? null : json["payment_code"],
  );
}
