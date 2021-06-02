class EmoneyDisbursementModel {
  EmoneyDisbursementModel({
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
  List<EmoneyDisbursementBody> body;
  dynamic error;

  factory EmoneyDisbursementModel.fromJson(Map<String, dynamic> json) => EmoneyDisbursementModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<EmoneyDisbursementBody>.from(json["body"].map((x) => EmoneyDisbursementBody.fromJson(x))),
    error: json["error"],
  );
}

class EmoneyDisbursementBody {
  EmoneyDisbursementBody({
    this.code,
    this.name,
  });

  String code;
  String name;

  factory EmoneyDisbursementBody.fromJson(Map<String, dynamic> json) => EmoneyDisbursementBody(
    code: json["code"] == null ? null : json["code"],
    name: json["name"] == null ? null : json["name"],
  );
}
