class BankDisbursementModel {
  BankDisbursementModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
    this.error,
  });

  int code;
  String message;
  int count;
  bool first;
  List<BankDisbursementBody> body;
  dynamic error;

  factory BankDisbursementModel.fromJson(Map<String, dynamic> json) => BankDisbursementModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<BankDisbursementBody>.from(json["body"].map((x) => BankDisbursementBody.fromJson(x))),
    error: json["error"],
  );
}

class BankDisbursementBody {
  BankDisbursementBody({
    this.code,
    this.name,
  });

  dynamic code;
  String name;

  factory BankDisbursementBody.fromJson(Map<String, dynamic> json) => BankDisbursementBody(
    code: json["code"] == null ? null : json["code"],
    name: json["name"] == null ? null : json["name"],
  );
}
