class DenomDisbursementModel {
  DenomDisbursementModel({
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
  List<DenomDisbursementBody> body;
  dynamic error;

  factory DenomDisbursementModel.fromJson(Map<String, dynamic> json) => DenomDisbursementModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<DenomDisbursementBody>.from(json["body"].map((x) => DenomDisbursementBody.fromJson(x))),
    error: json["error"],
  );
}

class DenomDisbursementBody {
  DenomDisbursementBody({
    this.code,
    this.name,
  });

  String code;
  String name;

  factory DenomDisbursementBody.fromJson(Map<String, dynamic> json) => DenomDisbursementBody(
    code: json["code"] == null ? null : json["code"],
    name: json["name"] == null ? null : json["name"],
  );
}
