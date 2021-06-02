class SubmitDisbursementModel {
  SubmitDisbursementModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int code;
  String message;
  SubmitDisbursementBody body;
  dynamic error;

  factory SubmitDisbursementModel.fromJson(Map<String, dynamic> json) => SubmitDisbursementModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    body: json["body"] == null ? null : SubmitDisbursementBody.fromJson(json["body"]),
    error: json["error"],
  );
}

class SubmitDisbursementBody {
  SubmitDisbursementBody({
    this.amount,
    this.classId,
    this.disburseStatus,
    this.trxid,
  });

  double amount;
  String classId;
  String disburseStatus;
  String trxid;

  factory SubmitDisbursementBody.fromJson(Map<String, dynamic> json) => SubmitDisbursementBody(
    amount: json["amount"] == null ? null : json["amount"],
    classId: json["classId"] == null ? null : json["classId"],
    disburseStatus: json["disburseStatus"] == null ? null : json["disburseStatus"],
    trxid: json["trxid"] == null ? null : json["trxid"],
  );
}
