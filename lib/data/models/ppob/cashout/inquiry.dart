class InquiryDisbursementModel {
  InquiryDisbursementModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  InquiryDisbursementBody body;
  dynamic error;

  factory InquiryDisbursementModel.fromJson(Map<String, dynamic> json) => InquiryDisbursementModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : InquiryDisbursementBody.fromJson(json["body"]),
    error: json["error"],
  );
}

class InquiryDisbursementBody {
  InquiryDisbursementBody({
    this.amount,
    this.balance,
    this.classId,
    this.token,
    this.totalAdminFee,
  });

  double amount;
  double balance;
  String classId;
  String token;
  double totalAdminFee;

  factory InquiryDisbursementBody.fromJson(Map<String, dynamic> json) => InquiryDisbursementBody(
    amount: json["amount"] == null ? null : json["amount"],
    balance: json["balance"] == null ? null : json["balance"],
    classId: json["classId"] == null ? null : json["classId"],
    token: json["token"] == null ? null : json["token"],
    totalAdminFee: json["totalAdminFee"] == null ? null : json["totalAdminFee"],
  );
}
